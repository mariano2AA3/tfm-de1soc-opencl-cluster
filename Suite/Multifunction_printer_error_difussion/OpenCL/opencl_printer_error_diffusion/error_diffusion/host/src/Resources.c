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
 *       Filename:  Resources.c
 *
 *    Description:  Utility functions
 *
 *        Version:  1.0
 *        Created:  10/02/2013 07:34:44 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */
/* #####   HEADER FILE INCLUDES   ################################################### */
#include "Resources.h"

/* #####   FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS   ############################ */

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  aligned_malloc
 *  Description:  Implements an aligned malloc if defined to be on the Altera SoC
 *  			platform.
 * =====================================================================================
 */
void* aligned_malloc(size_t size)
{
	void* ret = NULL;

#ifndef  NON_ALTERA
	posix_memalign( &ret, ACL_ALIGNMENT, size );
#else      /* -----  PLATFORM != ALTERA  ----- */
	ret = malloc( size);
#endif     /* -----  PLATFORM != ALTERA  ----- */
	return ret;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  aligned_free
 *  Description:  Implements and aligned free (simply calls free).
 * =====================================================================================
 */
void aligned_free( void* ptr )
{
	free( ptr );
}
