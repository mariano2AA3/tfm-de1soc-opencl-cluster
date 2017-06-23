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
 *       Filename:  OpenCL.h
 *
 *    Description:  OpenCL library to ease implementations
 *
 *        Version:  1.0
 *        Created:  10/21/2013 05:03:43 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */

#ifndef  OpenCL_INC
#define  OpenCL_INC
/* #####   HEADER FILE INCLUDES   ################################################### */
#include "CL/opencl.h"
#include "Types.h"

/* #####   EXPORTED TYPE DEFINITIONS   ############################################## */
typedef struct
{
	cl_platform_id		platform;
	cl_device_id		device;
	cl_context		context;
	cl_command_queue	dataQueue;
	cl_program		program;
}OpenCL_Environment;

typedef struct
{
	cl_kernel 		kernel;
	cl_command_queue	bufferQueue;
	cl_command_queue	execQueue;
}OpenCL_Kernel;

typedef struct
{
	cl_event*		events;
	uint			nEvents;

	void*			dataStruct;
	uint			dataStructSize;
	void**			data;
	uint*			pDataSize;
	cl_mem			buffer;
}OpenCL_Job;

/* #####   EXPORTED FUNCTION DECLARATIONS   ######################################### */

void OpenCL_ErrorMsg( int errorCode, int  line, const char* file ); /* Displays Error Message */
 /*----------------------------------------------------------------------------
 *  Environement Declarations
 *-----------------------------------------------------------------------------*/
bool OpenCL_Environment_init( OpenCL_Environment* e, const char* pName );
bool OpenCL_Environment_cleanup( OpenCL_Environment* e );


/*-----------------------------------------------------------------------------
 *  Kernel Declarations
 *-----------------------------------------------------------------------------*/
bool OpenCL_Kernel_init( OpenCL_Kernel* pKernel, OpenCL_Environment* pEnv, const char* kName );
bool OpenCL_Kernel_cleanup( OpenCL_Kernel* pKernel );


/*-----------------------------------------------------------------------------
 *  Job Declarations
 *-----------------------------------------------------------------------------*/
bool OpenCL_Job_init( OpenCL_Job* pJob, OpenCL_Environment* pEnv, void* dataStruct, uint dataStructSize, void** pData, uint* pDataSize );
bool OpenCL_Job_cleanup( OpenCL_Job* pJob, OpenCL_Environment* pEnv );

bool OpenCL_Job_enqueue( OpenCL_Job* pJob, 
			 OpenCL_Kernel* pKernel, 
			 uint wd,
			 size_t* gw_offset, 
			 size_t* gw_size,
			 size_t* lw_size );
#endif
