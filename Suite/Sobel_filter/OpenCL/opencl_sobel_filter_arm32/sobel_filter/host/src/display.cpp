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

#define NOMINMAX // so that windows.h does not define min/max macros

#include <CL/opencl.h>
#include <algorithm>
#include <iostream>
#include "parse_ppm.h"
  //             // Read rgb and pad
#include "defines.h"
#include "AOCLUtils/aocl_utils.h"
#include <unistd.h>
#include <time.h>
#include <stdio.h>

using namespace aocl_utils;

#define REFRESH_DELAY 10 //ms

unsigned int COLS = 1920;
unsigned int ROWS = 1080;
unsigned int thresh = 128;

int glutWindowHandle;
int graphicsWinWidth = 1024;
int graphicsWinHeight = (int)(((float) ROWS / (float) COLS) * graphicsWinWidth);
float fZoom = 1024;
int fps_raw = 0;

cl_uint *input = NULL;
cl_uint *output = NULL;

cl_uint num_platforms;
cl_platform_id platform;
cl_uint num_devices;
cl_device_id device;
cl_context context;
cl_command_queue queue;
cl_program program;
cl_kernel kernel;
#if USE_SVM_API == 0
cl_mem in_buffer, out_buffer;
#endif /* USE_SVM_API == 0 */

std::string imageFilename;
std::string aocxFilename;
std::string deviceInfo;


unsigned testThresholds[] = {32, 96, 128, 192, 225};
unsigned testFrameIndex = 0;


void teardown(int exit_status = 1);
void initCL();
void dumpFrame(unsigned *frameData);


void filter(unsigned int thresh) {

  size_t sobelSize = 1;
  cl_int status;

#if USE_SVM_API == 0
  status = clEnqueueWriteBuffer(queue, in_buffer, CL_FALSE, 0, sizeof(unsigned int) * ROWS * COLS, input, 0, NULL, NULL);
  checkError(status, "Error: could not copy data into device");

  status = clFinish(queue);
  checkError(status, "Error: could not finish successfully");
#endif /* USE_SVM_API == 0 */


  status = clSetKernelArg(kernel, 3, sizeof(unsigned int), &thresh);
  checkError(status, "Error: could not set sobel threshold");

  cl_event event;
  status = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &sobelSize, &sobelSize, 0, NULL, &event);
  checkError(status, "Error: could not enqueue sobel filter");

  status  = clFinish(queue);
  checkError(status, "Error: could not finish successfully");

  clReleaseEvent(event);

  
  
#if USE_SVM_API == 0
  status = clEnqueueReadBuffer(queue, out_buffer, CL_FALSE, 0, sizeof(unsigned int) * ROWS * COLS, output, 0, NULL, NULL);
  checkError(status, "Error: could not copy data from device");

  status = clFinish(queue);
  checkError(status, "Error: could not successfully finish copy");
#else
  status = clEnqueueSVMMap(queue, CL_TRUE, CL_MAP_READ,
      (void *)output, sizeof(unsigned int) * ROWS * COLS, 0, NULL, NULL);
  checkError(status, "Failed to map output");
#endif /* USE_SVM_API == 0 */

  
  // Dump out frame data in PPM (ASCII).
  dumpFrame(output);
  

#if USE_SVM_API == 1
  status = clEnqueueSVMUnmap(queue, (void *)output, 0, NULL, NULL);
  checkError(status, "Failed to unmap output");
#endif /* USE_SVM_API == 1 */
}

// Dump frame data in PPM format.
void dumpFrame(unsigned *frameData) {

  char fname[256];

  sprintf(fname, "out/%s_%d.ppm", (imageFilename.substr(0, imageFilename.length() - 4)).c_str(), thresh);

  printf("Dumping %s\n", fname);

  FILE *f = fopen(fname, "wb");
  fprintf(f, "P6 %d %d %d\n", COLS, ROWS, 255);
  
  for(unsigned y = 0; y < ROWS; ++y) {
    for(unsigned x = 0; x < COLS; ++x) {
      // This assumes byte-order is little-endian.
      unsigned pixel = frameData[y * COLS + x];
      fwrite(&pixel, 1, 3, f);
    }
  }
  fprintf(f, "\n");
  fclose(f);
}

int main(int argc, char **argv) {

  time_t start, end;
  double elapsed = 0.0f;
  
  Options options(argc, argv);

  imageFilename = "butterflies.ppm";
  if(options.has("img")) {
    imageFilename = options.get<std::string>("img");
  }

  if(options.has("thresh")) {
     thresh = options.get<int>("thresh");
  }

  if(options.has("w")) {
     COLS = options.get<int>("w");
  }

  if(options.has("h")) {
     ROWS = options.get<int>("h");
  }

  if (options.has("help")) {
    printf("Use:\n");
    printf(" -img=[imgPath.ppm]\n");
    printf(" -w=[imageWidth]\n");
    printf(" -h=[imageHeight]\n");
    printf(" -thresh={32, 96, 128, 192, 225}\n");
    teardown(0);
  }



#if USE_SVM_API == 0
  input = (cl_uint*)alignedMalloc(sizeof(unsigned int) * ROWS * COLS);
  output = (cl_uint*)alignedMalloc(sizeof(unsigned int) * ROWS * COLS);
#endif /* USE_SVM_API == 0 */

  
  initCL();

#if USE_SVM_API == 1
  status = clEnqueueSVMMap(queue, CL_TRUE, CL_MAP_WRITE,
      (void *)input, sizeof(unsigned int) * ROWS * COLS, 0, NULL, NULL);
  checkError(status, "Failed to map input");
#endif /* USE_SVM_API == 1 */

  // Read the image
  printf("Using ppm: %s\n", imageFilename.c_str());
  if (!parse_ppm(imageFilename.c_str(), COLS, ROWS, (unsigned char *)input)) {
    std::cerr << "Error: could not load " << argv[1] << std::endl;
    teardown();
  }


#if USE_SVM_API == 1
  status = clEnqueueSVMUnmap(queue, (void *)input, 0, NULL, NULL);
  checkError(status, "Failed to unmap input");
#endif /* USE_SVM_API == 1 */

  // Ejecutamos una vez el filtro
  time(&start);
  filter(thresh);
  time(&end);

  elapsed = difftime(end, start);

  printf("Execution time: %d\n", elapsed);

  teardown(0);
}

void initCL()
{
  cl_int status;

  if (!setCwdToExeDir()) {
    teardown();
  }

  platform = findPlatform("Altera");
  if (platform == NULL) {
    teardown();
  }

  status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, NULL);
  checkError (status, "Error: could not query devices");
  num_devices = 1; // always only using one device

  char info[256];
  clGetDeviceInfo(device, CL_DEVICE_NAME, sizeof(info), info, NULL);
  deviceInfo = info;

#if USE_SVM_API == 1
  cl_device_svm_capabilities caps = 0;

  status = clGetDeviceInfo(
    device,
    CL_DEVICE_SVM_CAPABILITIES,
    sizeof(cl_device_svm_capabilities),
    &caps,
    0
  );
  checkError(status, "Failed to get device info");

  if (!(caps & CL_DEVICE_SVM_COARSE_GRAIN_BUFFER)) {
    printf("The host was compiled with USE_SVM_API, however the device currently being targeted does not support SVM.\n");
    teardown();
  }
#endif /* USE_SVM_API == 1 */

  context = clCreateContext(0, num_devices, &device, &oclContextCallback, NULL, &status);
  checkError(status, "Error: could not create OpenCL context");

  queue = clCreateCommandQueue(context, device, 0, &status);
  checkError(status, "Error: could not create command queue");

  std::string binary_file = getBoardBinaryFile("sobel", device);
  std::cout << "Using AOCX: " << binary_file << "\n";
  program = createProgramFromBinary(context, binary_file.c_str(), &device, 1);

  status = clBuildProgram(program, num_devices, &device, "", NULL, NULL);
  checkError(status, "Error: could not build program");

  kernel = clCreateKernel(program, "sobel", &status);
  checkError(status, "Error: could not create sobel kernel");

#if USE_SVM_API == 0
  in_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(unsigned int) * ROWS * COLS, NULL, &status);
  checkError(status, "Error: could not create device buffer");

  out_buffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(unsigned int) * ROWS * COLS, NULL, &status);
  checkError(status, "Error: could not create output buffer");
#else
  input = (cl_uint*)clSVMAlloc(context, CL_MEM_READ_WRITE, sizeof(unsigned int) * ROWS * COLS, 0);
  if (NULL == input)
    checkError(-1, "Could not allocate input");
  output = (cl_uint*)clSVMAlloc(context, CL_MEM_READ_WRITE, sizeof(unsigned int) * ROWS * COLS, 0);
  if (NULL == output)
    checkError(-1, "Could not allocate output");
#endif /* USE_SVM_API == 0 */

  int pixels = COLS * ROWS;
#if USE_SVM_API == 0
  status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &in_buffer);
  checkError(status, "Error: could not set sobel arg 0");
  status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &out_buffer);
  checkError(status, "Error: could not set sobel arg 1");
#else
  status = clSetKernelArgSVMPointer(kernel, 0, (void *)input);
  checkError(status, "Error: could not set sobel arg 0");
  status = clSetKernelArgSVMPointer(kernel, 1, (void*)output);
  checkError(status, "Error: could not set sobel arg 1");
#endif /* USE_SVM_API == 0 */
  status = clSetKernelArg(kernel, 2, sizeof(int), &pixels);
  checkError(status, "Error: could not set sobel arg 2");
}





void cleanup()
{
  // Called from aocl_utils::check_error, so there's an error.
  teardown(-1);
}

void teardown(int exit_status)
{
#if USE_SVM_API == 0
  if (input) alignedFree(input);
  if (output) alignedFree(output);
  if (in_buffer) clReleaseMemObject(in_buffer);
  if (out_buffer) clReleaseMemObject(out_buffer);
#else
  if (input) clSVMFree(context, input);
  if (output) clSVMFree(context, output);
#endif /* USE_SVM_API == 0 */
  if (kernel) clReleaseKernel(kernel);
  if (program) clReleaseProgram(program);
  if (queue) clReleaseCommandQueue(queue);
  if (context) clReleaseContext(context);

  exit(exit_status);
}


