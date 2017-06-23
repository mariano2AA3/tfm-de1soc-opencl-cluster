
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
#include <cmath>

using namespace aocl_utils;



// cl_uint *input = NULL;
pixel* input = NULL;
pixel* output = NULL;
double* filter = NULL;
//cl_uint *output = NULL;

cl_uint num_platforms;
cl_platform_id platform;
cl_uint num_devices;
cl_device_id device;
cl_context context;
cl_command_queue queue;
cl_program program;
cl_kernel kernel;
#if USE_SVM_API == 0
cl_mem in_buffer, out_buffer, filter_buffer;
#endif /* USE_SVM_API == 0 */

std::string imageFileName;
std::string resultFileName;
char header[3];
int color_depth = 255;
std::string aocxFilename;
std::string deviceInfo;


void teardown(int exit_status = 1);
void initCL(const int width, const int height, const int radius);

int image_write(pixel* pixels, const char *file_name, const char *header, const int width, const int height, const int color_depth);

void apply_blur(const int radius, const int width, const int height) {

  size_t blurSize = 1;
  cl_int status;
  int dim = 2 * radius + 1;

#if USE_SVM_API == 0
  status = clEnqueueWriteBuffer(queue, in_buffer, CL_FALSE, 0, sizeof(pixel) * width * height, input, 0, NULL, NULL);
  checkError(status, "Error: could not copy input data into device");

  status = clEnqueueWriteBuffer(queue, filter_buffer, CL_FALSE, 0, sizeof(double) * dim * dim, filter, 0, NULL, NULL);
  checkError(status, "Error: could not copy filter data into device");

  status = clFinish(queue);
  checkError(status, "Error: could not finish successfully");
#endif /* USE_SVM_API == 0 */


  status = clSetKernelArg(kernel, 3, sizeof(int), &radius);
  checkError(status, "Error: could not set blur radius");

  status = clSetKernelArg(kernel, 4, sizeof(int), &width);
  checkError(status, "Error: could not set blur width");

  status = clSetKernelArg(kernel, 5, sizeof(int), &height);
  checkError(status, "Error: could not set blur height");



  cl_event event;
  status = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &blurSize, &blurSize, 0, NULL, &event);
  checkError(status, "Error: could not enqueue blur filter");

  status  = clFinish(queue);
  checkError(status, "Error: could not finish successfully");

  clReleaseEvent(event);

  
  
#if USE_SVM_API == 0
  status = clEnqueueReadBuffer(queue, out_buffer, CL_FALSE, 0, sizeof(pixel) * width * height, output, 0, NULL, NULL);
  checkError(status, "Error: could not copy data output from device");

  status = clFinish(queue);
  checkError(status, "Error: could not successfully finish copy");
#else
  status = clEnqueueSVMMap(queue, CL_TRUE, CL_MAP_READ,
      (void *)output, sizeof(pixel) * width * height, 0, NULL, NULL);
  checkError(status, "Failed to map output");
#endif /* USE_SVM_API == 0 */

  
  // Dump out frame data in PPM (ASCII).
  printf("Dumping result...\n");
  image_write(output, resultFileName.c_str(), header, width, height, color_depth);
  

#if USE_SVM_API == 1
  status = clEnqueueSVMUnmap(queue, (void *)output, 0, NULL, NULL);
  checkError(status, "Failed to unmap output");
#endif /* USE_SVM_API == 1 */
}


pixel* image_load(const char *image_name, char* header, int* width, int* height, int* color_depth) {
	
	//Open file
	FILE *file = fopen(image_name, "r");
	if(!file)
		return NULL;

	//Read image info
	fscanf(file, "%s", header);
	fscanf(file, "%d %d %d", width, height, color_depth);

	//Alocate memory for pixels
	pixel* pixels = (pixel*)malloc(sizeof(pixel) * *width * *height);
	int i,j;
	//Read pixels
	for(i = 0; i < *height; i++)
		for(j = 0; j < *width; j++)
			fscanf(file, "%c%c%c", &(pixels[j + i * *width].R), &(pixels[j + i * *width].G), &(pixels[j + i * *width].B));

	//Close file
	fclose(file);

	return pixels;
}


int image_write(pixel* pixels, const char *file_name, const char *header, const int width, const int height, const int color_depth) {
	
	//Open file
	FILE *file = fopen(file_name, "w");
	if(!file)
		return 0;
	
	//Write image info
	fprintf(file, "%s\n%d %d\n%d", header, width, height, color_depth);

	//Write pixels
	int i, j;
	for(i = 0; i < height; i++)
		for(j = 0; j < width; j++)
			fprintf(file, "%c%c%c", pixels[j + i * width].R, pixels[j + i * width].G, pixels[j + i * width].B);

	//Write EOF
	fprintf(file, "%d", EOF);

	//Close file
	fclose(file);

	return 1;
}


double gauss_2d(int x, int y, double sigma) {
	
	double result = 1.0 / (2 * PI * sigma * sigma);
	result *= exp(-(x*x+y*y)/(2 * sigma * sigma));
	
	
	return result;
}


double* filter_create_gauss(int radius, double sigma) {

	//Used for iterations
	int i, j;

	//The matrix width and height
	int dim = 2*radius+1;

	//Alocate mem for the matrix
	double* filter = (double*) malloc(sizeof(double) * dim * dim);

	//Calculate
	double sum = 0.0, sum_old= 0.0;
	double g = 0.0;
	
	for(i = -radius; i <= radius; i++)
		for(j = -radius; j <= radius; j++) {
			filter[(j+radius) + (i+radius) * dim] = gauss_2d(j, i, sigma);
			sum += filter[ (j+radius) + (i+radius) * dim];
		}


	//Correct so that the sum of all elements ~= 1
	for(i = 0; i < 2*radius+1; i++) {
		for(j = 0; j < 2*radius+1; j++) {
			filter[j + i * dim] /= sum;
		}
	}

	return filter;
}


void filter_print(double* filter, const int radius) {
	
	int dim = 2*radius+1, i, j;

	printf("FILTER: \n");

	for(i = 0; i < dim; i++) {
		for(j = 0; j < dim; j++) 
			printf("\t%lf ", filter[j + i * dim]);
		printf("\n");
	}
}


int main(int argc, char **argv) {

  time_t start, end;
  double elapsed = 0.0f;
  
  Options options(argc, argv);

  imageFileName   = "butterflies.ppm";
  resultFileName = "out_blur_butterflies.ppm";
  int width       = 1920; 
  int height      = 1080; 
  int radius      = 1;
  double sigma = 5.0f;
  int dim = 0;


  if(options.has("input")) {
    imageFileName = options.get<std::string>("input");
  }

  if(options.has("w")) {
    width = options.get<int>("w");
  }

  if(options.has("h")) {
    height = options.get<int>("h");
  }

  if(options.has("output")) {
     resultFileName = options.get<std::string>("output");
  }

  if(options.has("r")) {
     radius = options.get<int>("r");
  }

  if(options.has("s")) {
     sigma = options.get<int>("s");
  }

  if (options.has("help")) {
    printf("Use:\n");
    printf(" -input=[inputImgPath.ppm]\n");
    printf(" -w=[width]\n");
    printf(" -h=[height]\n");
    printf(" -output=[outputImgPath.ppm]\n");
    printf(" -r=[radius]\n");
    printf(" -s=[sigma]\n");
    teardown(0);
  }


  dim = 2 * radius + 1;

#if USE_SVM_API == 0
  input = (pixel*)alignedMalloc(sizeof(pixel) * width * height);
  output = (pixel*)alignedMalloc(sizeof(pixel) * width * height);
  filter = (double*)alignedMalloc(sizeof(double) * dim *dim);
#endif /* USE_SVM_API == 0 */

  initCL(width, height, radius);

#if USE_SVM_API == 1
  status = clEnqueueSVMMap(queue, CL_TRUE, CL_MAP_WRITE,
      (void *)input, sizeof(pixel) * width * height, 0, NULL, NULL);
  checkError(status, "Failed to map input");

  status = clEnqueueSVMMap(queue, CL_TRUE, CL_MAP_WRITE,
      (void *)filter, sizeof(double) * dim * dim, 0, NULL, NULL);
  checkError(status, "Failed to map filter");

#endif /* USE_SVM_API == 1 */

  // Read the image
  printf("Loading ppm image...%s\n", imageFileName.c_str());
  input = image_load(imageFileName.c_str(), header, &width, &height, &color_depth);  

  // Create filter
  printf("Creating filter [radius=%d, sigma=%e]...\n", radius, sigma);
  filter = filter_create_gauss(radius, sigma);
  filter_print(filter, radius);

#if USE_SVM_API == 1
  status = clEnqueueSVMUnmap(queue, (void *)input, 0, NULL, NULL);
  checkError(status, "Failed to unmap input");

  status = clEnqueueSVMUnmap(queue, (void *)filter, 0, NULL, NULL);
  checkError(status, "Failed to unmap filter");


  status = clEnqueueSVMUnmap(queue, (void *)output, 0, NULL, NULL);
  checkError(status, "Failed to unmap input");

#endif /* USE_SVM_API == 1 */

  // Ejecutamos una vez el filtro
  time(&start);
  apply_blur(radius, width, height);
  time(&end);

  elapsed = difftime(end, start);

  printf("Execution time: %d\n", elapsed);

  teardown(0);
}

void initCL(const int width, const int height, const int radius) {

  cl_int status;
  int dim = 2 * radius + 1;

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

  std::string binary_file = getBoardBinaryFile("blur", device);
  std::cout << "Using AOCX: " << binary_file << "\n";
  program = createProgramFromBinary(context, binary_file.c_str(), &device, 1);

  status = clBuildProgram(program, num_devices, &device, "", NULL, NULL);
  checkError(status, "Error: could not build program");

  kernel = clCreateKernel(program, "blur", &status);
  checkError(status, "Error: could not create blur kernel");

#if USE_SVM_API == 0
  in_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(pixel) * width * height, NULL, &status);
  checkError(status, "Error: could not create device buffer_in");

  filter_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(double) * dim * dim, NULL, &status);
  checkError(status, "Error: could not create device buffer_filter");

  out_buffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(pixel) * width * height, NULL, &status);
  checkError(status, "Error: could not create device buffer_out");
#else
  input = (pixel*)clSVMAlloc(context, CL_MEM_READ_WRITE, sizeof(pixel) * width * height, 0);
  if (NULL == input)
    checkError(-1, "Could not allocate input");

  filter = (double*)clSVMAlloc(context, CL_MEM_READ_WRITE, sizeof(double) * dim * dim, 0);
  if (NULL == filter)
    checkError(-1, "Could not allocate filter");

  output = (pixel*)clSVMAlloc(context, CL_MEM_READ_WRITE, sizeof(pixel) * width * height, 0);
  if (NULL == output)
    checkError(-1, "Could not allocate output");
#endif /* USE_SVM_API == 0 */

  int pixels = width * height;;
#if USE_SVM_API == 0
  status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &in_buffer);
  checkError(status, "Error: could not set blur arg 0");
  status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &out_buffer);
  checkError(status, "Error: could not set blur arg 1");
  status = clSetKernelArg(kernel, 2, sizeof(cl_mem), &filter_buffer);
  checkError(status, "Error: could not set blur arg 2");

#else
  status = clSetKernelArgSVMPointer(kernel, 0, (void *)input);
  checkError(status, "Error: could not set blur arg 0");
  status = clSetKernelArgSVMPointer(kernel, 1, (void*)output);
  checkError(status, "Error: could not set blur arg 1");
  status = clSetKernelArgSVMPointer(kernel, 2, (void *)filter);
  checkError(status, "Error: could not set blur arg 2");

#endif /* USE_SVM_API == 0 */
  status = clSetKernelArg(kernel, 3, sizeof(int), &radius);
  checkError(status, "Error: could not set blur arg 3");

  status = clSetKernelArg(kernel, 4, sizeof(int), &width);
  checkError(status, "Error: could not set blur arg 4");

  status = clSetKernelArg(kernel, 5, sizeof(int), &height);
  checkError(status, "Error: could not set blur arg 5");

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
  if (filter) alignedFree(filter);
  if (output) alignedFree(output);
  if (in_buffer) clReleaseMemObject(in_buffer);
  if (filter_buffer) clReleaseMemObject(filter_buffer);
  if (out_buffer) clReleaseMemObject(out_buffer);
#else
  if (input) clSVMFree(context, input);
  if (filter) clSVMFree(context, filter);
  if (output) clSVMFree(context, output);
#endif /* USE_SVM_API == 0 */
  if (kernel) clReleaseKernel(kernel);
  if (program) clReleaseProgram(program);
  if (queue) clReleaseCommandQueue(queue);
  if (context) clReleaseContext(context);

  exit(exit_status);
}



