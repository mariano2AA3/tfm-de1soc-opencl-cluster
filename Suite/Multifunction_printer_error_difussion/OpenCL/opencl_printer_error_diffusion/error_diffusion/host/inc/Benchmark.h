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
 *       Filename:  Benchmark.h
 *
 *    Description:  Describes benchmarking struct and functions
 *
 *        Version:  1.0
 *        Created:  10/04/2013 10:45:48 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */

#ifndef  Benchmark_INC
#define  Benchmark_INC

/* #####   HEADER FILE INCLUDES   ################################################### */
#include <time.h>
#include "Types.h"

/* #####   EXPORTED DATA TYPES   #################################################### */
typedef struct
{
	char		name[32];
	clockid_t	cid;
	struct timespec	start;
	struct timespec	stop;
	double 		offset;
}Benchmark;

/* #####   EXPORTED FUNCTION DECLARATIONS   ######################################### */
bool Benchmark_init( Benchmark* pBm, const char* name );   /* Initializes Benchmark Struct */
bool Benchmark_start( Benchmark* pBm );         /* Starts the Benchmark timer */
bool Benchmark_stop( Benchmark* pBm );          /* Stops the Benchmark timer */
float Benchmark_duration( Benchmark* pBm );     /* Returns the duration of the Benchmark timer */

bool Benchmark_report( Benchmark* pBmArray, int numBm ); /* Generates a report from Benchmarks */
#endif   /* ----- #ifndef Benchmark_INC  ----- */

