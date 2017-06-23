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


unsigned int COLS = 1920;
unsigned int ROWS = 1080;;
unsigned int thresh = 32;

bool parse_ppm(const char *filename, const unsigned int width, const unsigned int height, unsigned char *data) {
  FILE *fp = NULL;
#ifdef _WIN32
  errno_t err;
  if ((err = fopen_s(&fp, filename, "rb")) != 0)
#else
  if ((fp = fopen(filename, "rb")) == 0)
#endif
  {
    if (fp) { fclose(fp); }
    return false;
  }

  const size_t headerSize = 0x40;
  char header[headerSize];
  if ((fgets(header, headerSize, fp) == NULL) && ferror(fp)) {
    if (fp) { fclose(fp); }
    return false;
  }

  if (strncmp(header, "P6", 2) != 0) {
    return false;
  }

  int i = 0;
  unsigned int maxval = 0;
  unsigned int w = 0;
  unsigned int h = 0;

  while (i < 3) {
    if ((fgets(header, headerSize, fp) == NULL) && ferror(fp)) {
      if (fp) { fclose(fp); }
      return false;
    }
    // Skip comments
    if (header[0] == '#') continue;
#ifdef _WIN32
    if (i == 0) {
      i += sscanf_s(header, "%u %u %u", &w, &h, &maxval);
    } else if (i == 1) {
      i += sscanf_s(header, "%u %u", &h, &maxval);
    } else if (i == 2) {
      i += sscanf_s(header, "%u", &maxval);
    }
#else
    if (i == 0) {
      i += sscanf(header, "%u %u %u", &w, &h, &maxval);
    } else if (i == 1) {
      i += sscanf(header, "%u %u", &h, &maxval);
    } else if (i == 2) {
      i += sscanf(header, "%u", &maxval);
    }
#endif
  }

  if (maxval == 0) {
    if (fp) { fclose(fp); }
    return false;
  }
  if (maxval > 255) {
    if (fp) { fclose(fp); }
    return false;
  }

  if (w != width) {
    if (fp) { fclose(fp); }
    return false;
  }

  if (h != height) {
    if (fp) { fclose(fp); }
    return false;
  }

  unsigned char *raw = (unsigned char *)malloc(sizeof(unsigned char) * width * height * 3);
  if (!raw) {
    if (fp) { fclose(fp); }
    return false;
  }

  if (fread(raw, sizeof(unsigned char), width * height * 3, fp) != width * height * 3) {
    if (fp) { fclose(fp); }
    return false;
  }
  if (fp) { fclose(fp); }

  // Transfer the raw data
  unsigned char *raw_ptr = raw;
  unsigned char *data_ptr = data;

  int e = width * height;
  for (i = 0; i != e; ++i) {
    // Read rgb and pad
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = 0;
  }
  free(raw);
  return true;
}


void dump_frame(unsigned *frameData) {

  char fname[256];
  unsigned y, x;

  sprintf(fname, "out_laplace_%d.ppm", thresh);

  printf("Dumping %s\n", fname);

  FILE *f = fopen(fname, "wb");
  fprintf(f, "P6 %d %d %d\n", COLS, ROWS, 255);
  
  for(y = 0; y < ROWS; ++y) {
    for(x = 0; x < COLS; ++x) {
      // This assumes byte-order is little-endian.
      unsigned pixel = frameData[y * COLS + x];
      fwrite(&pixel, 1, 3, f);
    }
  }
  fprintf(f, "\n");
  fclose(f);
}


int main(int argc, char** argv) {

   if ( argc != 4 ) {
      printf("Error. Uso: ./laplace_filter INPUT_IMAGE WIDTH HEIGHT\n");
      return -1;
   }


    // char filename[40] = "1_butterflies_1080.ppm";
    // char filename[40] = argv[1];
    COLS = atoi(argv[2]);    
    ROWS = atoi(argv[3]);
    printf("Using image %s, W=%d, H=%d\n", argv[1], COLS, ROWS);

    cl_uint *input = (cl_uint*) malloc(sizeof(unsigned int) * ROWS * COLS);
    cl_uint *output = (cl_uint*) malloc(sizeof(unsigned int) * ROWS * COLS);
   
    if(!parse_ppm(argv[1], COLS, ROWS, (unsigned char*) input)) {
      printf("Error al leer la imagen de entrada\n");
      return -1;
    }


    // Load the kernel source code into the array source_str
    FILE *fp;
    char *source_str;
    size_t source_size;

    fp = fopen("laplace.cl", "r");
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
    cl_context context = clCreateContext( NULL, 1, &device_id, NULL, NULL, &ret);

    // Create a command queue
    cl_command_queue command_queue = clCreateCommandQueue(context, device_id, 0, &ret);

    // Create memory buffers on the device for each vector
   cl_mem in_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, 
                          sizeof(unsigned int) * ROWS * COLS, NULL, &ret);

   cl_mem out_buffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, 
                          sizeof(unsigned int) * ROWS * COLS, NULL, &ret);


    // Copy the lists A and B to their respective memory buffers
    ret = clEnqueueWriteBuffer(command_queue, in_buffer, CL_FALSE, 0, 
              sizeof(unsigned int) * ROWS * COLS, input, 0, NULL, NULL);
    

    // Create a program from the kernel source
    cl_program program = clCreateProgramWithSource(context, 1, 
            (const char **)&source_str, (const size_t *)&source_size, &ret);

    // Build the program
    ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
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
    cl_kernel kernel = clCreateKernel(program, "laplacian", &ret);

    // Set the arguments of the kernel
    int pixels = COLS * ROWS;
    ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), &in_buffer);
    ret = clSetKernelArg(kernel, 1, sizeof(cl_mem), &out_buffer);
    ret = clSetKernelArg(kernel, 2, sizeof(int), &pixels);
    ret = clSetKernelArg(kernel, 3, sizeof(unsigned int), &thresh);
    
    // Execute the OpenCL kernel on the list
    cl_event event;

    /////
    size_t global_item_size = 2; 
    size_t local_item_size = 2;
    ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, 
            &global_item_size, &local_item_size, 0, NULL, &event);
    ////
    
    // ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, 
    //        &size, &size, 0, NULL, &event);

    ret = clFinish(command_queue);
    printf("Finish: %d\n", ret);
    clReleaseEvent(event);

    

    // Read the memory buffer C on the device to the local variable C
    ret = clEnqueueReadBuffer(command_queue, out_buffer, CL_FALSE, 0, 
            sizeof(unsigned int) * ROWS * COLS, output, 0, NULL, NULL);

    // Display the result to the screen
    dump_frame(output);

    // Clean up
    ret = clFlush(command_queue);
    ret = clFinish(command_queue);
    ret = clReleaseKernel(kernel);
    ret = clReleaseProgram(program);
    ret = clReleaseMemObject(in_buffer);
    ret = clReleaseMemObject(out_buffer);
    ret = clReleaseCommandQueue(command_queue);
    ret = clReleaseContext(context);
    free(input);
    free(output);
    return 0;
}

