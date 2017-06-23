// Copyright (C) 2013-2017 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.

// Optical Flow Host 
//
// written by Dmitry Denisenko in November, 2013

#include <iostream>
#include <math.h>
#include "CL/opencl.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string>

#include "AOCLUtils/aocl_utils.h"
#include "clKernelSet.hpp"
#include "clChannelUtils.h"

using namespace aocl_utils;

// Input data (two successive frames) is taken from files.
// These files simply contain grayscale pixel values on scale of 0 to 255.
// const char image_file1[] = "input1.raw";
// const char image_file2[] = "input2.raw";
std::string image_file1;
std::string image_file2;
const int WIDTH =1280;
const int HEIGHT =800;
const int NUM_PIXELS = WIDTH * HEIGHT;

typedef cl_uchar uchar;


// Image access without bounds wrapping.
#define PO(image,x,y,W) ((image)[(y)*(W)+(x)])
// Image access with bounds wrapping.
#define P(image,x,y,W,H) ((image)[( (y)>=H ? H-1 : ((y)<0 ? 0:(y)) )*(W)+( (x)>=W ? W-1 : ((x)<0 ? 0 : (x)) )])

bool init_platform();
bool run();
void cleanup();
bool save_image (const char *outf, uchar *image1, int width, int height, char grayscale);
bool read_image_raw (const char *outf, uchar *image1, int width, int height);

// global variables
// ACL runtime configuration
static cl_platform_id platform;
static cl_device_id device;
static cl_context context;
static cl_program program;
static cl_int status;
static cl_command_queue queue;

static cl_mem src1, src2, dst, colour;
static uchar *v_src1 = 0, *v_src2 = 0;
static cl_uchar4 *v_dst = 0;
static int *v_colour = 0;

static unsigned num_iters = 100;

int main( int argc, char** argv )
{
  // Options processing.
  Options options(argc, argv);
  if(options.has("iters")) {
    num_iters = options.get<unsigned>("iters");
  }

  image_file1 = "input1.raw";
  image_file2 = "input2.raw";
  if(options.has("input1")) {
    image_file1 = options.get<std::string>("input1");
  }
  if(options.has("input2")) {
    image_file2 = options.get<std::string>("input2");
  }

  printf("Running %d iterations over %s and %s\n", num_iters, image_file1.c_str(), image_file2.c_str());

  // Initialize OpenCL, run and cleanup.
  if(!init_platform()) return 1;
  if(!run()) return 1;
  cleanup();
  return 0;
}


// save image as a PPM
bool save_image_ppm (const char *outf, cl_uchar4 *image1, int width, int height) {
  FILE *output = fopen (outf, "wb");
  if (output == NULL) {
    printf ("Couldn't open %s for writing!\n", outf);
    return false;
  }
  fprintf(output, "P6\n%d %d\n%d\n", width, height, 255);
  for (int j = 0; j < height; j++) {
    for (int i = 0; i < width; i++) {
      // Pixels are in RGB format (and order).
      fwrite(&image1[j*width + i], 1, 3, output);
    }
  }
  fclose (output);
  return true;
}

// Read in image consisting of "raw" numbers. Each number represents a pixel
// value in grayscale.
bool read_image_raw (const char *outf, uchar *image1, int width, int height) {
  FILE *input = fopen (outf, "r");
  if (input == NULL) {
    printf ("Couldn't open %s for reading!\n", outf);
    return false;
  }
  for (int j = 0; j < height; j++) {
    for (int i = 0; i < width; i++) {
      fscanf (input, "%hhu ", &(image1[j*width+i]));
    }
    fscanf (input, "\n");
  }
  fclose (input);
  return true;
}



template <typename T >
cl_mem alloc_shared_buffer (size_t size, T **vptr) {
  cl_mem res = clCreateBuffer(context, CL_MEM_ALLOC_HOST_PTR, sizeof(T) * size, NULL, &status);
  checkError(status, "Failed to create buffer");

  assert (vptr != NULL);
  *vptr = (T*)clEnqueueMapBuffer(queue, res, CL_TRUE, CL_MAP_WRITE|CL_MAP_READ, 0, sizeof(T) * size, 0, NULL, NULL, NULL);
  assert (*vptr != NULL);
  // populate the buffer with garbage data
  for (size_t i=0; i< size; i++) {
    *((uchar*)(*vptr) + i) = 13;
  }
  return res;
}

template <typename T>
void dump_2d (const char *name, T *data, size_t width, size_t height, const char *format) {
  printf ("---------------\n");
  printf ("name: %s\n", name);
  for(size_t j = 0; j < height; j++) {
    for(size_t i = 0; i < width; i++) {
      printf (format, data[j*width+i]);
    }
    printf ("\n");
  }
  printf ("\n");
}

#define MAXCOLS 60
void setcols(int *colourwheel, int r, int g, int b, int k) {
  *(colourwheel + k*3 + 0) = r;
  *(colourwheel + k*3 + 1) = g;
  *(colourwheel + k*3 + 2) = b;
}

void makecolourwheel(int* colourwheel, int * ncols) {
  // relative lengths of colour transitions:
  // these are chosen based on perceptual similarity
  // (e.g. one can distinguish more shades between red and yellow 
  //  than between yellow and green)
  int RY = 15;
  int YG = 6;
  int GC = 4;
  int CB = 11;
  int BM = 13;
  int MR = 6;
  *ncols = RY + YG + GC + CB + BM + MR;
  if (*ncols > MAXCOLS)
    return;
  int i;
  int k = 0;
  for (i = 0; i < RY; i++) setcols(colourwheel, 255,	   255*i/RY,	 0,	       k++);
  for (i = 0; i < YG; i++) setcols(colourwheel, 255-255*i/YG, 255,		 0,	       k++);
  for (i = 0; i < GC; i++) setcols(colourwheel, 0,		   255,		 255*i/GC,     k++);
  for (i = 0; i < CB; i++) setcols(colourwheel, 0,		   255-255*i/CB, 255,	       k++);
  for (i = 0; i < BM; i++) setcols(colourwheel, 255*i/BM,	   0,		 255,	       k++);
  for (i = 0; i < MR; i++) setcols(colourwheel, 255,	   0,		 255-255*i/MR, k++);
}


bool run() {
  printf("Allocating buffers\n");
  src1 = alloc_shared_buffer<uchar> (NUM_PIXELS, &v_src1);
  src2 = alloc_shared_buffer<uchar> (NUM_PIXELS, &v_src2);
  dst  = alloc_shared_buffer<cl_uchar4> (NUM_PIXELS, &v_dst);
  colour  = alloc_shared_buffer<int> (MAXCOLS*3, &v_colour);
    
  printf("Build colour palette\n");
  int ncols;
  makecolourwheel (v_colour, &ncols);
  
  printf("Reading input images\n");
  if(!read_image_raw (image_file1.c_str(), v_src1, WIDTH, HEIGHT)) return false;
  if(!read_image_raw (image_file2.c_str(), v_src2, WIDTH, HEIGHT)) return false;
  
  printf("Initializing kernels\n");
  size_t task_dim = 1;
  clKernelSet kernel_set (device, context, program);
  kernel_set.addKernel ("optical_flow_for_images", 1, &task_dim, src1, src2, dst);
  
  printf("Launching the kernel...\n");
  
  // Launch multiple iterations of the kernel - this'll be used for timing.
  double start_time = getCurrentTimestamp();
  for(unsigned i = 0; i < num_iters; ++i) {
    kernel_set.launch();
  }
  kernel_set.finish();
  double elapsed_time = getCurrentTimestamp() - start_time;
  
  printf("%d iterations time: %0.3f seconds\n", num_iters, elapsed_time);
  printf("Average single iteration time: %0.3f seconds\n", elapsed_time / num_iters);
  printf("Throughput = %d FPS\n", (int)(num_iters/elapsed_time));
 
  char fname[256];
  sprintf(fname, "out/out_%s%s.ppm", (image_file1.substr(0, image_file1.length() - 4)).c_str(), (image_file2.substr(0, image_file2.length() - 4)).c_str() );
 
  printf ("Saving output buffer to %s\n", fname);
  if(!save_image_ppm (fname, v_dst, WIDTH, HEIGHT)) return false;
 
  return true;
}

bool init_platform() {
  cl_uint num_devices;

  // set current dir to exe's location. Will help find aocx
  if(!setCwdToExeDir()) {
    return false;
  }

  // Get the OpenCL platform.
  // platform = findPlatform("Intel(R) FPGA");
  platform = findPlatform("Altera");
  if(platform == NULL) {
    printf("ERROR: Unable to find Intel(R) FPGA OpenCL platform.\n");
    return false;
  }

  // Query the available OpenCL device.
  cl_device_id *devices = getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices);
  printf("Platform: %s\n", getPlatformName(platform).c_str());
  printf("Found %d device(s)\n", num_devices);

  // Just use the first device.
  device = devices[0];
  printf("Using %s\n", getDeviceName(device).c_str());
  delete[] devices;

  // Create a context.
  context = clCreateContext(0, 1, &device, &oclContextCallback, NULL, &status);
  checkError(status, "Failed to create context");

  // Create command queue.
  queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
  checkError(status, "Failed to create command queue");

  // Create the program using binary already compiled offline using aoc (i.e. the .aocx file)
  std::string binary_file = getBoardBinaryFile("optical_flow", device);
  printf("Using AOCX: %s\n", binary_file.c_str());

  program = createProgramFromBinary(context, binary_file.c_str(), &device, 1);

  // build the program
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
  checkError(status, "Failed to build program");

  return true;
}


// free the resources allocated during initialization
void cleanup() {
  if (v_src1) {
    clEnqueueUnmapMemObject (queue, src1, v_src1, 0, NULL, NULL);
    clReleaseMemObject (src1);
    v_src1 = 0;
  }
  if (v_src2) {
    clEnqueueUnmapMemObject (queue, src2, v_src2, 0, NULL, NULL);
    clReleaseMemObject (src2);
    v_src2 = 0;
  }
  if (v_dst) {
    clEnqueueUnmapMemObject (queue, dst, v_dst, 0, NULL, NULL);
    clReleaseMemObject (dst);
    v_dst = 0;
  }
  if (v_colour) {
    clEnqueueUnmapMemObject (queue, colour, v_colour, 0, NULL, NULL);
    clReleaseMemObject (colour);
    v_colour = 0;
  }

  if(program) {
    clReleaseProgram(program);
  }
  if(queue) {
    clReleaseCommandQueue(queue);
  }
  if(context) {
    clReleaseContext(context);
  }
}

