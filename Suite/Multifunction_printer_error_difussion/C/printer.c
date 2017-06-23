#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "inc/Image.h"
#include "inc/EDState.h"

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif

#define MAX_SOURCE_SIZE (0x100000)
#define BUFFER_OFFSET	4
#define HALFTONE_VALUE	0x7F

bool ErrorDiffusion_C( Image* pImage )
{

	/*-----------------------------------------------------------------------------
 * 	 *  Image Parameters
 * 	 	 *-----------------------------------------------------------------------------*/
	uint height 	= pImage->height;
	uint width 	= pImage->width;
	uint nChannels 	= pImage->channels;
	
	uint byteWidth  = width*nChannels;

	uint eBufferSize = (width + BUFFER_OFFSET + 1)*nChannels;
	/*-----------------------------------------------------------------------------
 * 	 *  Variables
 * 	 	 *-----------------------------------------------------------------------------*/
	uchar* pPixel 		= NULL;
	
	signed char* errorBuffer 	= NULL;
	signed char* errorCell	= NULL;
	
	signed int oPixel		= 0;
	signed int nPixel		= 0;
	signed char error	= 0;

	
	uint i			= 0;
	uint j			= 0;
	
	/*-----------------------------------------------------------------------------
 * 	 *  Allocate space for the error buffer
 * 	 	 *-----------------------------------------------------------------------------*/
	errorBuffer = (signed char*)valloc( sizeof( signed char ) * eBufferSize ); 
	if( errorBuffer == NULL )
	{
		return false;
	}
	errorCell = errorBuffer;
	for( i = 0; i < eBufferSize; i++ )
	{
		*(errorCell++) = 0;
	}
	
	pPixel = pImage->pixels;
	for( i = 0; i < height; i++ )
	{	
		errorCell = errorBuffer + BUFFER_OFFSET*nChannels;
		for( j = 0; j < byteWidth; j++)
		{
		
			oPixel = 	*(pPixel);
			oPixel +=	*(errorCell);
		
			(oPixel > HALFTONE_VALUE)?(nPixel = 0xFF):(nPixel = 0x00);
			*(pPixel++) = (uchar)nPixel;

			error = oPixel - nPixel;

			error = error >> 1;             /* error/2 */
			*(errorCell + nChannels) += error;

			error = error >> 1;             /* error/4 */
			*(errorCell) = error;

			error = error >> 1;             /* error/8 */
			*(errorCell - nChannels) += error;

			error = error >> 1;             /* error/16 */
			*(errorCell - (nChannels*2)) += error;

			error = error >> 1;              /* error/32 */
			*(errorCell - (nChannels*3)) += error;
			*(errorCell - nChannels*4) += error;

			errorCell++;
		}
	}

	free( errorBuffer );
	return true;
}


int main(int argc, char** argv) {

   if ( argc != 3 ) {
      printf("Error. Uso: ./printer INPUT.tif OUTPUT.tif\n");
      return -1;
   }

    EDState edState;
    edState.iImage = argv[1];
    edState.oImage = argv[2];


    printf("Using image %s\n", edState.iImage);

    //cl_uint *input = (cl_uint*) malloc(sizeof(unsigned int) * ROWS * COLS);
    //cl_uint *output = (cl_uint*) malloc(sizeof(unsigned int) * ROWS * COLS);
   
    // Read Images
    printf("Reading input image...");
    if( Image_read( &edState.image, edState.iImage ) != true ) {
	fprintf( stderr, "Failed to read %s from file.\n", edState.iImage );
	return EXIT_FAILURE;
    }
    printf("Done\n");


   // C execution
   
   printf("Running C execution...");
   ErrorDiffusion_C(&edState.image);
   printf("Done\n");

    printf("Writting output result...");
    if( Image_write( &edState.image, edState.oImage ) != true ) {
        fprintf( stderr, "Failed to write image %s.\n", edState.oImage );
        return EXIT_FAILURE;
    }
    printf("Done\n");

   return 0;
   
   // C


    // Load the kernel source code into the array source_str
    FILE *fp;
    char *source_str;
    size_t source_size;

    fp = fopen("ErrorDiffusion.cl", "r");
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
    cl_mem buffer = clCreateBuffer( context, CL_MEM_ALLOC_HOST_PTR | CL_MEM_COPY_HOST_PTR, edState.image.size, (void **)edState.image.pixels, &ret );
   // cl_mem in_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(unsigned int) * ROWS * COLS, NULL, &ret);

   // cl_mem out_buffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(unsigned int) * ROWS * COLS, NULL, &ret);


    // Copy the lists A and B to their respective memory buffers
    // ret = clEnqueueWriteBuffer(command_queue, in_buffer, CL_FALSE, 0, sizeof(unsigned int) * ROWS * COLS, input, 0, NULL, NULL);
   edState.image.pixels = (void*)clEnqueueMapBuffer(command_queue, buffer, CL_TRUE, CL_MAP_READ | CL_MAP_WRITE, 0,edState.image.size, 0, NULL, NULL, &ret ); 

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
    cl_kernel kernel = clCreateKernel(program, "errorDiffusion", &ret);

    // Set the arguments of the kernel
    ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer);
    ret = clSetKernelArg(kernel, 1, sizeof(uint), &edState.image.height);
    ret = clSetKernelArg(kernel, 2, sizeof(uint), &edState.image.width);
    ret = clSetKernelArg(kernel, 3, sizeof(uint), &edState.image.channels);
    
    // Execute the OpenCL kernel on the list
    cl_event event;

    size_t global_item_size = 1; 
    size_t local_item_size = 1;
    ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, 
            &global_item_size, &local_item_size, 0, NULL, &event);
    
    ret = clFinish(command_queue);
    printf("Finish: %d\n", ret);
    clReleaseEvent(event);

    

    // Read the memory buffer C on the device to the local variable C
    // ret = clEnqueueReadBuffer(command_queue, out_buffer, CL_FALSE, 0, sizeof(unsigned int) * ROWS * COLS, output, 0, NULL, NULL);

    // Display the result to the screen
    printf("Writting output result...");
    if( Image_write( &edState.image, edState.oImage ) != true ) {
	fprintf( stderr, "Failed to write image %s.\n", edState.oImage );
	return EXIT_FAILURE;
    }
    printf("Done\n");

    // Clean up
    ret = clFlush(command_queue);
    ret = clFinish(command_queue);
    ret = clReleaseKernel(kernel);
    ret = clReleaseProgram(program);
    //ret = clReleaseMemObject(in_buffer);
    //ret = clReleaseMemObject(out_buffer);
    ret = clReleaseCommandQueue(command_queue);
    ret = clReleaseContext(context);
    //free(input);
    //free(output);
    return 0;
}

