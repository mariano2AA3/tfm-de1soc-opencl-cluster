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

/*
 * =====================================================================================
 *
 *       Filename:  OpenCL.c
 *
 *    Description:  OpenSL library to ease implementations
 *
 *        Version:  1.0
 *        Created:  10/21/2013 05:56:10 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */

/* #####   HEADER FILE INCLUDES   ################################################### */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "OpenCL.h"
#include "Resources.h"
#include "Types.h"

/* #####   PROTOTYPES  -  LOCAL TO THIS SOURCE FILE   ############################### */

/*-----------------------------------------------------------------------------
 *  Environment local prototypes
 *-----------------------------------------------------------------------------*/
int OpenCL_Environment_initPlatform( OpenCL_Environment* e );
int OpenCL_Environment_initDevice( OpenCL_Environment* e );
int OpenCL_Environment_initContext( OpenCL_Environment* e );
int OpenCL_Environment_initDataQueue( OpenCL_Environment* e );
int OpenCL_Environment_initProgram( OpenCL_Environment* e, const char* pName );

/* #####   FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS   ############################ */
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_ErrorMsg
 *  Description:  Displays the error code to the user
 * =====================================================================================
 */
void OpenCL_ErrorMsg( int errorCode, int line, const char* file )
{
	fprintf( stderr, "Error: Received error code %d on line %d in %s\n", errorCode, line, file);
}

/*-----------------------------------------------------------------------------
 *  Environment Functions
 *-----------------------------------------------------------------------------*/

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_init
 *  Description:  Initializes OpenCL Environment
 * =====================================================================================
 */
bool OpenCL_Environment_init( OpenCL_Environment* pE, const char* pName )
{

	int error;

	/*-----------------------------------------------------------------------------
	 *  Initialize all variables to defaults
	 *-----------------------------------------------------------------------------*/
	pE->platform 	= NULL;
	pE->device 	= NULL;
	pE->context 	= NULL;
	pE->dataQueue = NULL;
	pE->program 	= NULL;
	

	/*-----------------------------------------------------------------------------
	 *  Get the values of the variables and error check
	 *-----------------------------------------------------------------------------*/
	if( (error = OpenCL_Environment_initPlatform( pE )) != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error , __LINE__, __FILE__ );
		return false;
	}
	if( (error = OpenCL_Environment_initDevice( pE )) != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	if( (error = OpenCL_Environment_initContext( pE )) != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	if( (error = OpenCL_Environment_initDataQueue( pE )) != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	if( (error = OpenCL_Environment_initProgram( pE, pName )) != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}

	return true;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_cleanup
 *  Description:  Cleans up the OpenCL environment. Returns true if successful, false
 *  			otherwise
 * =====================================================================================
 */
bool OpenCL_Environment_cleanup( OpenCL_Environment* pE )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;
	

	/*-----------------------------------------------------------------------------
	 *  Execution
	 *-----------------------------------------------------------------------------*/
	if( pE->context != NULL )
	{
		error = clReleaseContext( pE->context );
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}
		pE->context = NULL;
	}
	if( pE->dataQueue != NULL )
	{
		error = clReleaseCommandQueue( pE->dataQueue );
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}
		pE->dataQueue = NULL;
	}
	return true;
}


/*-----------------------------------------------------------------------------
 *  Kernel Functions
 *-----------------------------------------------------------------------------*/
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Kernel_init
 *  Description:  Initializes an OpenCL kernel
 * =====================================================================================
 */
bool OpenCL_Kernel_init( OpenCL_Kernel* pKernel, OpenCL_Environment* pEnv, const char* kName )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;


	/*-----------------------------------------------------------------------------
	 *  Initialize the kernel to default values
	 *-----------------------------------------------------------------------------*/
	pKernel->bufferQueue = NULL;
	pKernel->execQueue = NULL;
	pKernel->kernel = NULL;


	/*-----------------------------------------------------------------------------
	 *  Create the kernel and queues
	 *-----------------------------------------------------------------------------*/
	pKernel->bufferQueue = clCreateCommandQueue( pEnv->context, pEnv->device, 0, &error );
	if( error != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	
	pKernel->execQueue = clCreateCommandQueue( pEnv->context, pEnv->device, 0, &error );
	if( error != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}

	
	/*-----------------------------------------------------------------------------
	 *  We might be using this to make a fake kernel for loading jobs, in that case
	 *  we do not actually create the kernels
	 *-----------------------------------------------------------------------------*/
	if( kName != NULL )
	{
		pKernel->kernel = clCreateKernel( pEnv->program, kName, &error);
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}		
	}
	
	return true;

}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Kernel_cleanup
 *  Description:  Cleans up the opencl kernels
 * =====================================================================================
 */
bool OpenCL_Kernel_cleanup( OpenCL_Kernel* pKernel )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;


	/*-----------------------------------------------------------------------------
	 *  Perform Cleanup
	 *-----------------------------------------------------------------------------*/
	if( pKernel->kernel != NULL )
	{
		error = clReleaseKernel( pKernel->kernel );
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}
		pKernel->kernel = NULL;
	}
	if( pKernel->bufferQueue != NULL )
	{
		error = clReleaseCommandQueue( pKernel->bufferQueue );
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}
		pKernel->bufferQueue = NULL;

	}
	if( pKernel->execQueue != NULL )
	{
		error = clReleaseCommandQueue( pKernel->execQueue );
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}
		pKernel->execQueue = NULL;

	}

	return true;
}	


/*-----------------------------------------------------------------------------
 *  Job Functions
 *-----------------------------------------------------------------------------*/

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Job_init
 *  Description:  Initializes an OpenCL Job by taking in the data structure associated, 
 *  			the data array to be processed by the kernel, and the sizes of
 *  			each. The mapped data buffer must be reassigned in the data 
 *  			structure if you want to use it outside of OpenCL functions.
 * =====================================================================================
 */
bool OpenCL_Job_init( 	OpenCL_Job* pJob, 
			OpenCL_Environment* pEnv, 
			void* pStruct, 
			uint structSize,
			void** pData,
			uint* pDataSize	)
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;


	/*-----------------------------------------------------------------------------
	 *  Initialize Struct to default values
	 *-----------------------------------------------------------------------------*/
	pJob->events = 		NULL;
	pJob->nEvents =		0;
	pJob->dataStruct = 	NULL;
	pJob->dataStructSize =	0;
	pJob->data = 		NULL;
	pJob->pDataSize = 	NULL;
	pJob->buffer = 		NULL;

	/*-----------------------------------------------------------------------------
	 *  Store the elements in the Job struct that we can
	 *-----------------------------------------------------------------------------*/
	pJob->dataStruct = pStruct;
	pJob->dataStructSize = structSize;

	/*-----------------------------------------------------------------------------
	 *  We must allocate
	 *-----------------------------------------------------------------------------*/
	if( pEnv == NULL )
	{
		return false;
	}
	pJob->buffer = clCreateBuffer( 	pEnv->context, 
					CL_MEM_ALLOC_HOST_PTR | CL_MEM_COPY_HOST_PTR,
					*pDataSize, 
					*pData,
					&error );
	if( error != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
	}
	
	aligned_free( *pData );
	
	*pData = (void*)clEnqueueMapBuffer( 	pEnv->dataQueue, 
						pJob->buffer, 
						CL_TRUE, 
						CL_MAP_READ | CL_MAP_WRITE,
						0,
						*pDataSize, 
						0,
						NULL,
						NULL, 
						&error );
	if( error != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
	}
	pJob->data = pData;
	pJob->pDataSize = pDataSize;
	return true;

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Job_cleanup
 *  Description:  Cleans up the Job struct so no memory leaks occur
 * =====================================================================================
 */
bool OpenCL_Job_cleanup( OpenCL_Job* pJob, OpenCL_Environment* pEnv )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;
	uint i = 0;

	/*-----------------------------------------------------------------------------
	 *  Begin releasing things
	 *-----------------------------------------------------------------------------*/
	if( pJob->buffer != NULL )
	{
		clEnqueueUnmapMemObject( 	pEnv->dataQueue,
						pJob->buffer,
						*pJob->data,
						pJob->nEvents,
						pJob->events,
						NULL );
		error = clReleaseMemObject( pJob->buffer );
		*pJob->data = NULL;
		if( error != CL_SUCCESS )
		{
			OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
			return false;
		}
	}
	if( *pJob->data != NULL )
	{
		aligned_free( *pJob->data );
		*pJob->data = NULL;

	}
	for( i = 0; i < pJob->nEvents; i++ )
	{	
		if( pJob->events[i] != NULL )
		{
			error = clReleaseEvent( pJob->events[i] );
			if( error != CL_SUCCESS )
			{
				OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
				return false;
			}
			pJob->events[i] = NULL;
		}
	}
	if( pJob->events != NULL )
	{
		aligned_free( pJob->events );
		pJob->events = NULL;
	}
	return true;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Job_enqueue
 *  Description:  Enqueues the OpenCL Job to the specified kernel
 * =====================================================================================
 */
bool OpenCL_Job_enqueue( OpenCL_Job* pJob,
			 OpenCL_Kernel* pKernel,
			 uint wd,
			 size_t* gw_offset,
			 size_t* gw_size,
			 size_t* lw_size )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;
	cl_event* tempEvents;

	/*-----------------------------------------------------------------------------
	 *  We need to create a new event for this, but we must add it to our Job's 
	 *  event list so we can just enqueue all kernels and execute them at the end
	 *-----------------------------------------------------------------------------*/
	tempEvents = (cl_event*)aligned_malloc( sizeof(cl_event)*(pJob->nEvents + 1) );
	memcpy( tempEvents, pJob->events, sizeof(cl_event)*pJob->nEvents );
	tempEvents[pJob->nEvents] = NULL;
	aligned_free( pJob->events );
	pJob->events = tempEvents;

	error =	clEnqueueNDRangeKernel( pKernel->execQueue,
					pKernel->kernel,
					wd,
					gw_offset,
					gw_size,
					lw_size,
					pJob->nEvents,
					(pJob->nEvents==0)?(NULL):(pJob->events),
					&pJob->events[pJob->nEvents] );

	/*-----------------------------------------------------------------------------
	 *  Increment the nEvents so the next kernel we add the job to will wait on this
	 *  kernel to finish
	 *-----------------------------------------------------------------------------*/
	pJob->nEvents++;
	if( error != CL_SUCCESS )
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );

		/*-----------------------------------------------------------------------------
		 *  If it fails, then we must deallocate the generated event so we don't screw
		 *  anything up
		 *-----------------------------------------------------------------------------*/
		pJob->nEvents--;
		tempEvents = (cl_event*)aligned_malloc( sizeof(cl_event)*pJob->nEvents );
		memcpy( tempEvents, pJob->events, sizeof(cl_event)*pJob->nEvents );
		pJob->events = tempEvents;
		return false;
	}
	return true;

}	


/* #####   FUNCTION DEFINITIONS  -  LOCAL TO THIS SOURCE FILE   ##################### */



/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_initPlatform
 *  Description:  Sets the platform of the OpenCL environment, returns the error code
 * =====================================================================================
 */
int OpenCL_Environment_initPlatform( OpenCL_Environment* pE )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	cl_platform_id temp;
	int err = 0;
	uint nPlat;

	/*-----------------------------------------------------------------------------
	 *  Execution
	 *-----------------------------------------------------------------------------*/
	err = clGetPlatformIDs(1, &temp, &nPlat);
	if( err == CL_SUCCESS )
	{
		pE->platform = temp;
	}
	return err;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_initDevice
 *  Description:  Sets the device id in the OpenCL Environment. Returns the error code
 * =====================================================================================
 */
int OpenCL_Environment_initDevice( OpenCL_Environment* pE )
{
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;
	uint devices = 0;

	/*-----------------------------------------------------------------------------
	 *  Execution
	 *-----------------------------------------------------------------------------*/
	error = clGetDeviceIDs( pE->platform, CL_DEVICE_TYPE_ALL, 1, &pE->device, &devices );
	return error;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_initContext
 *  Description:  Sets the context and returns the error code
 * =====================================================================================
 */
int OpenCL_Environment_initContext( OpenCL_Environment* pE )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;

	/*-----------------------------------------------------------------------------
	 *  Execution
	 *-----------------------------------------------------------------------------*/
	pE->context = clCreateContext( 0, 1, &pE->device, NULL, NULL, &error );
	return error;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_initDataQueue
 *  Description:  Initializes the OpenCL environment data queue, returns the error code
 * =====================================================================================
 */
int OpenCL_Environment_initDataQueue( OpenCL_Environment* pE )
{
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;

	/*-----------------------------------------------------------------------------
	 *  Execution
	 *-----------------------------------------------------------------------------*/
	pE->dataQueue = clCreateCommandQueue( pE->context, pE->device, 0, &error );
	return error;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  OpenCL_Environment_initProgram
 *  Description:  Initializes the program and returns the error code
 * =====================================================================================
 */
int OpenCL_Environment_initProgram( OpenCL_Environment* pE, const char* pName )
{
	#ifndef NON_ALTERA

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	FILE*		fHandle;                /* Input file handle */
	size_t		fSize;                  /* The input file size */
	uchar*		progBuffer;             /* Stores the program characters */
	
	int 		error;
	int		status;

	
	/*-----------------------------------------------------------------------------
   * If no program file name is given, use default.
	 *-----------------------------------------------------------------------------*/
	if( pName == NULL )
	{
    pName = "ErrorDiffusion.aocx";
	}
	/*-----------------------------------------------------------------------------
	 *  Read in the program file
	 *-----------------------------------------------------------------------------*/
	fHandle = fopen( pName, "rb" );
	if( fHandle ==  NULL )
	{
		return CL_INVALID_PROGRAM;
	}
	fseek( fHandle, 0, SEEK_END );
	fSize = ftell( fHandle );
	progBuffer = (uchar*)aligned_malloc( sizeof(uchar)*fSize );
	rewind( fHandle );

	if(fread( (void*)progBuffer, fSize, 1, fHandle ) == 0 )
	{
		fclose( fHandle );
		aligned_free( progBuffer );
		return false;
	}
	fclose( fHandle );

	/*-----------------------------------------------------------------------------
	 *  Build the program from the source
	 *-----------------------------------------------------------------------------*/
	pE->program = clCreateProgramWithBinary( pE->context, 
						 1, 
						 &pE->device, 
						 &fSize, 
						 (const uchar**)&progBuffer,
						 &status, 
						 &error 	);
	if( error != CL_SUCCESS )
	{
		aligned_free( progBuffer );
		return error;
	}
	
	error = clBuildProgram( pE->program, 
				1, 
				&pE->device, 
				"-cl-no-signed-zeros", 
				NULL, 
				NULL	);
	aligned_free( progBuffer );
	return error;
	
	#else
	///////////////////////
	// File I/O
	///////////////////////
	FILE*		fHandle;				// Input file handle
	long int	fSize;					// Input file size
	char*		progBuf;		// Buffer to store the contents of the input file

	///////////////////////
	// Debug
	///////////////////////
	size_t	log_size;					// Size of the build log generated when compile fails
	char*	log;						// Build log

	///////////////////////
	// Error
	///////////////////////
	cl_int	err = 0;					// Error detection

	///// Write the contents of the source file to memory /////
	fHandle = fopen(pName, "rb");
	if( fHandle == NULL )
	{
		return CL_BUILD_ERROR;
	}
	fseek(fHandle, 0, SEEK_END);
	fSize = ftell(fHandle);
	progBuf = (char*)aligned_malloc(sizeof(char)*((unsigned long int)fSize + 1));
	rewind(fHandle);
	fread(progBuf, sizeof(char), (size_t)fSize, fHandle);
	fclose(fHandle);
	progBuf[fSize] = '\0';

	///// Create the program from the source code /////
	pE->program = clCreateProgramWithSource(pE->context, 1, (const char**)&progBuf, (const size_t*)&fSize, &err);
	if( err != CL_SUCCESS )
	{
		aligned_free( progBuf );
		return err;
	}

	///// Build the program on the specified device /////
	err = clBuildProgram(pE->program , 1, &pE->device, "-cl-opt-disable", NULL, NULL);

	///// If the build fails, display the build log /////
	if (err != CL_SUCCESS) {
		clGetProgramBuildInfo(pE->program, pE->device, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);		// Determine the size of the log
		log = (char *)aligned_malloc(log_size);														// Allocate memory for the log
		clGetProgramBuildInfo(pE->program, pE->device, CL_PROGRAM_BUILD_LOG, log_size, log, NULL);	// Get the log
		printf("%s\n", log);																	// Print the log
		free(log);
		return err;																				// Free the allocated memory
	}
	free(progBuf);
	return CL_SUCCESS;
	#endif
}







