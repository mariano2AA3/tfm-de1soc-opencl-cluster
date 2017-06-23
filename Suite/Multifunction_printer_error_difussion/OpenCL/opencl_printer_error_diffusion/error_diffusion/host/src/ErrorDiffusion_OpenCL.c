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
 *       Filename:  ErrorDiffusion_OpenCL.c
 *
 *    Description:  Describes the OpenCL Error Diffusion Implementation
 *
 *        Version:  1.0
 *        Created:  11/13/2013 07:24:33 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */
/* #####   HEADER FILE INCLUDES   ################################################### */
#include "CL/opencl.h"
#include "ErrorDiffusion_OpenCL.h"
#include "Image.h"

/* #####   FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS   ############################ */
bool ErrorDiffusion_OpenCL( OpenCL_Kernel* pKernel, OpenCL_Job* pJob )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int error = 0;
	Image* pImage = NULL;
	size_t gw_size = 1;
	size_t lw_size = 1;
		
	pImage = (Image*)pJob->dataStruct;
	error = clSetKernelArg( pKernel->kernel, 0, sizeof(cl_mem), &pJob->buffer );
	if( error != CL_SUCCESS)
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	error = clSetKernelArg( pKernel->kernel, 1, sizeof(uint), &pImage->height );
	if( error != CL_SUCCESS)
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	error = clSetKernelArg( pKernel->kernel, 2, sizeof(uint), &pImage->width );
	if( error != CL_SUCCESS)
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	error = clSetKernelArg( pKernel->kernel, 3, sizeof(uint), &pImage->channels );
	if( error != CL_SUCCESS)
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}

	if( OpenCL_Job_enqueue( pJob, pKernel, 1, NULL, &gw_size, &lw_size ) != true )
	{
		return false;
	}
	error = clFinish( pKernel->execQueue );	
	if( error != CL_SUCCESS)
	{
		OpenCL_ErrorMsg( error, __LINE__, __FILE__ );
		return false;
	}
	return true;
	
}


