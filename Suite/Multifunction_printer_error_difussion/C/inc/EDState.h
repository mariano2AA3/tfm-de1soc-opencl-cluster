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
 *       Filename:  EDState.h
 *
 *    Description:  Describes the Error Diffusion State sturcture
 *
 *        Version:  1.0
 *        Created:  10/21/2013 04:45:15 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */
#ifndef  EDState_INC
#define  EDState_INC
/* #####   HEADER FILE INCLUDES   ################################################### */
#include "Image.h"
#include "OpenCL.h"
#include "Types.h"

/* #####   EXPORTED TYPE DEFINITIONS   ############################################## */
typedef struct
{
	const char*		iImage;
	const char*		oImage;
	const char*		ocImage;
	const char*		oclProgram;

	OpenCL_Environment 	environment;
	
	OpenCL_Kernel		kernels[1];
	int			nKernels;
	
	OpenCL_Job		job;
	Image			image;
	Image			cImage;

	int			verbose;
	int			report;
}EDState;
#endif   /* ----- #ifndef EDState_INC  ----- */

