#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif

#include <assert.h>

#include "clChannelUtils.h"

#define MAX_SOURCE_SIZE (0x100000)

#define WIDTH 1280
#define HEIGHT 800

const char image_file1[] = "input1.raw";
const char image_file2[] = "input2.raw";
const int NUM_PIXELS = WIDTH * HEIGHT;
unsigned num_iters = 1;

static cl_context context;
static cl_command_queue command_queue;

typedef cl_uchar uchar;

// Image access without bounds wrapping.
#define PO(image,x,y,W) ((image)[(y)*(W)+(x)])
// Image access with bounds wrapping.
#define P(image,x,y,W,H) ((image)[( (y)>=H ? H-1 : ((y)<0 ? 0:(y)) )*(W)+( (x)>=W ? W-1 : ((x)<0 ? 0 : (x)) )])

static cl_mem src1, src2, dst, colour;
static int *v_colour = 0;
static uchar *v_src1 = 0, *v_src2 = 0;
static cl_uchar4 *v_dst = 0;


bool save_image_ppm (const char *outf, cl_uchar4 *image1, int width, int height) {
  FILE *output = fopen (outf, "wb");
  if (output == NULL) {
    printf ("Couldn't open %s for writing!\n", outf);
    return false;
  }
  fprintf(output, "P6\n%d %d\n%d\n", width, height, 255);
  int i,j;
  for (j = 0; j < height; j++) {
    for (i = 0; i < width; i++) {
      // Pixels are in RGB format (and order).
      fwrite(&image1[j*width + i], 1, 3, output);
   }
    }
   fclose (output);
   return true;
}


bool read_image_raw (const char *outf, uchar *image1, int width, int height) {
  FILE *input = fopen (outf, "r");
  if (input == NULL) {
    printf ("Couldn't open %s for reading!\n", outf);
    return false;
  }
  int i,j;
  for (j = 0; j < height; j++) {
    for (i = 0; i < width; i++) {
      fscanf (input, "%hhu ", &(image1[j*width+i]));
    }
    fscanf (input, "\n");
  }
  fclose (input);
  return true;
}


#define MAXCOLS 60
void setcols(int *colourwheel, int r, int g, int b, int k) {
  *(colourwheel + k*3 + 0) = r;
  *(colourwheel + k*3 + 1) = g;
  *(colourwheel + k*3 + 2) = b;
}

void makecolourwheel(int* colourwheel, int* ncols) {

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
  for (i = 0; i < RY; i++) setcols(colourwheel, 255, 255*i/RY, 0, k++);
  for (i = 0; i < YG; i++) setcols(colourwheel, 255-255*i/YG, 255, 0, k++);
  for (i = 0; i < GC; i++) setcols(colourwheel, 0, 255, 255*i/GC, k++);
  for (i = 0; i < CB; i++) setcols(colourwheel, 0,	255-255*i/CB, 255, k++);
  for (i = 0; i < BM; i++) setcols(colourwheel, 255*i/BM, 0, 255, k++);
  for (i = 0; i < MR; i++) setcols(colourwheel, 255, 0, 255-255*i/MR, k++);
}


cl_mem alloc_shared_buffer_uchar (size_t size, uchar **vptr) {

  cl_int status;

  cl_mem res = clCreateBuffer(context, CL_MEM_ALLOC_HOST_PTR, sizeof(uchar) * size, NULL, &status);

  assert (vptr != NULL);
  *vptr = (uchar*)clEnqueueMapBuffer(command_queue, res, CL_TRUE, CL_MAP_WRITE|CL_MAP_READ, 0, sizeof(uchar) * size, 0, NULL, NULL, NULL);
  assert (*vptr != NULL);
  size_t i; 
  for (i=0; i< size; i++) {
     *((uchar*)(*vptr) + i) = 13;
  }
  return res;
}


cl_mem alloc_shared_buffer_cl_uchar4 (size_t size, cl_uchar4 **vptr) {
  cl_int status;

  cl_mem res = clCreateBuffer(context, CL_MEM_ALLOC_HOST_PTR, sizeof(cl_uchar4) * size, NULL, &status);

  assert (vptr != NULL);
  *vptr = (cl_uchar4*)clEnqueueMapBuffer(command_queue, res, CL_TRUE, CL_MAP_WRITE|CL_MAP_READ, 0, sizeof(cl_uchar4) * size, 0, NULL, NULL, NULL);
  assert (*vptr != NULL);
  size_t i;
  for (i=0; i< size; i++) {
     *((uchar*)(*vptr) + i) = 13;
  }
  return res;
}


cl_mem alloc_shared_buffer_int (size_t size, int **vptr) {
  cl_int status;

  cl_mem res = clCreateBuffer(context, CL_MEM_ALLOC_HOST_PTR, sizeof(int) * size, NULL, &status);

  assert (vptr != NULL);
  *vptr = (int*)clEnqueueMapBuffer(command_queue, res, CL_TRUE, CL_MAP_WRITE|CL_MAP_READ, 0, sizeof(int) * size, 0, NULL, NULL, NULL);
  assert (*vptr != NULL);
  size_t i;
  for (i=0; i< size; i++) {
     *((uchar*)(*vptr) + i) = 13;
  }
  return res;
}


int main(int argc, char** argv) {

    printf("Running %d iterations\n", num_iters);

    // Load the kernel source code into the array source_str
    FILE *fp;
    char *source_str;
    size_t source_size;

    fp = fopen("optical_flow.cl", "r");
    if (!fp) {
        fprintf(stderr, "Failed to load kernel.\n");
        exit(1);
    }
    source_str = (char*)malloc(MAX_SOURCE_SIZE);
    source_size = fread( source_str, 1, MAX_SOURCE_SIZE, fp);
    fclose( fp );

    // Get platform and device information
    cl_platform_id platform_id = NULL;
    cl_device_id device_id = NULL;   
    cl_uint ret_num_devices;
    cl_uint ret_num_platforms;
    cl_int ret = clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
    ret = clGetDeviceIDs( platform_id, CL_DEVICE_TYPE_ALL, 1, 
            &device_id, &ret_num_devices);

    // Create an OpenCL context
    context = clCreateContext( NULL, 1, &device_id, NULL, NULL, &ret);

    // Create a command queue
    command_queue = clCreateCommandQueue(context, device_id, 0, &ret);

    // Create memory buffers on the device for each vector
    printf("Allocating buffers\n"); 
    src1 = alloc_shared_buffer_uchar(NUM_PIXELS, &v_src1);
    src2 = alloc_shared_buffer_uchar(NUM_PIXELS, &v_src2);
    dst =  alloc_shared_buffer_cl_uchar4(NUM_PIXELS, &v_dst);
    colour =  alloc_shared_buffer_int(MAXCOLS*3, &v_colour);

    printf("Build colour palette\n");
    int ncols;
    makecolourwheel (v_colour, &ncols);

    printf("Reading input images\n");
    if(!read_image_raw (image_file1, v_src1, WIDTH, HEIGHT)) return false;
    if(!read_image_raw (image_file2, v_src2, WIDTH, HEIGHT)) return false;



    // Create a program from the kernel source
    cl_program program = clCreateProgramWithSource(context, 1, 
            (const char **)&source_str, (const size_t *)&source_size, &ret);

    // Build the program
    ret = clBuildProgram(program, 1, &device_id, "-cl-fast-relaxed-math", NULL, NULL);
    if( ret != CL_SUCCESS ) {
	printf("Error Build: %d\n", ret);
	// Determine the size of the log
	size_t log_size;
	clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);
	// Allocate memory for the log
	char *log = (char *) malloc(log_size);
	// Get the log
	clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, log_size, log, NULL);
	// Print the log
	printf("%s\n", log);	
	exit(1);
    }

    // Create the OpenCL kernel
    cl_kernel kernel = clCreateKernel(program, "optical_flow_for_images", &ret);

    // Set the arguments of the kernel

    ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&src1);
    ret = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&src2);
    ret = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void*)&dst);
    
    
    // Execute the OpenCL kernel on the list
    cl_event event;


    size_t global_item_size = 2;        // 128
    size_t local_item_size = 2;		// 64
    unsigned i;
   for(i=0; i < num_iters; i++) {
        ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, &global_item_size, &local_item_size, 0, NULL, &event);
        if (ret != CL_SUCCESS) {
        printf ("Failed to launch kernel. Error %d\n", ret);
      }
    }

  
    for(i=0; i < num_iters; i++) {
       ret = clFinish(command_queue);
       if (ret != CL_SUCCESS) {
        printf ("clFinish failed on queue for kernel. Error %d\n", ret);
      }
    }

    clReleaseEvent(event);

    // Display the result to the screen
    printf("Writting result image\n");
    if(!save_image_ppm ("out.ppm", v_dst, WIDTH, HEIGHT)) return false; 

    // Clean up
    
    ret = clEnqueueUnmapMemObject (command_queue, src1, v_src1, 0, NULL, NULL);
    ret = clEnqueueUnmapMemObject (command_queue, src2, v_src2, 0, NULL, NULL);
    ret = clEnqueueUnmapMemObject (command_queue, dst, v_dst, 0, NULL, NULL);
    ret = clEnqueueUnmapMemObject (command_queue, colour, v_colour, 0, NULL, NULL);
    ret = clFlush(command_queue);
    ret = clFinish(command_queue);
    ret = clReleaseKernel(kernel);
    ret = clReleaseProgram(program);
    ret = clReleaseMemObject(src1);
    ret = clReleaseMemObject(src2);
    ret = clReleaseMemObject(dst);
    ret = clReleaseMemObject(colour);
    ret = clReleaseCommandQueue(command_queue);
    ret = clReleaseContext(context);
    return 0;
}

