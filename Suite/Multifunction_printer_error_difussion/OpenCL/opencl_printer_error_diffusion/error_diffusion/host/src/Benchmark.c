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
 *       Filename:  Benchmark.c
 *
 *    Description:  Describes the benchmarking functions
 *
 *        Version:  1.0
 *        Created:  10/04/2013 10:54:56 AM
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
#include <string.h>

#include "Benchmark.h"

/* #####   FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS   ############################ */


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Benchmark_init
 *  Description:  Initializes the benchmark struct with the cpu clock id
 * =====================================================================================
 */
bool Benchmark_init( Benchmark* pBm, const char* name )
{
	clock_getcpuclockid(0, &pBm->cid);
	strcpy( pBm->name, name );
	Benchmark_start( pBm );
	Benchmark_stop( pBm );
	pBm->offset = 0;
	pBm->offset = Benchmark_duration( pBm );
	pBm->start.tv_sec 	= 0;
	pBm->start.tv_nsec 	= 0;
	pBm->stop.tv_sec	= 0;
	pBm->stop.tv_nsec	= 0;
	
	return true;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Benchmark_start
 *  Description:  Starts the benchmark timer
 * =====================================================================================
 */
bool Benchmark_start( Benchmark* pBm )
{
	clock_gettime( pBm->cid, &pBm->start );
	return true;
}
bool Benchmark_stop( Benchmark* pBm )
{
	clock_gettime( pBm->cid, &pBm->stop );
	return true; 
}
float Benchmark_duration( Benchmark* pBm )
{ 
	float duration_sec = 0.0;
	float duration_ns = 0.0;
	duration_sec = (float)(pBm->stop.tv_sec - pBm->start.tv_sec);
	duration_ns = (float)(pBm->stop.tv_nsec - pBm->start.tv_nsec);
	duration_ns /= 1E9;
	return duration_sec + duration_ns - pBm->offset; 
}
bool Benchmark_report( Benchmark* pBmArray, int numBm  )
{	
	int i = 0; 
	double total = 0.0;
	fprintf( stdout, "\nBenchmark Report\n" );
	/*-----------------------------------------------------------------------------
	 *  Generate Top of Report Frame
	 *-----------------------------------------------------------------------------*/
	for ( i = 0; i < 41; i++)
	{
		fprintf( stdout, "-" );
	}
	fprintf( stdout, "\n" );
	/*-----------------------------------------------------------------------------
	 *  Generate heading first
	 *-----------------------------------------------------------------------------*/
	fprintf ( stdout, "|%19s|%19s|\n","Kernel","Execution Time");
	
	for ( i = 0; i < 41; i++)
	{
		fprintf( stdout, "-" );
	}
	fprintf( stdout, "\n" );

	/*-----------------------------------------------------------------------------
	 *  Iterate through array of Benchmarks to display report details
	 *-----------------------------------------------------------------------------*/
	
	for ( i = 0; i < numBm; i++ ) 
	{
		total += Benchmark_duration( &pBmArray[i] );
		fprintf( stdout, "|%19s|%19.9f|\n", pBmArray[i].name, Benchmark_duration( &pBmArray[i]) );
	}

	/*-----------------------------------------------------------------------------
	 *  Generate bottom of frame
	 *-----------------------------------------------------------------------------*/
	
	for ( i = 0; i < 41; i++)
	{
		fprintf( stdout, "-" );
	}
	fprintf( stdout, "\n" );
	fprintf( stdout, "|%19s|%19.9f|\n", "Total", total );
	for ( i = 0; i < 41; i++ )
	{
		fprintf( stdout , "-" );
	}
	fprintf( stdout, "\n" );
	return true; 
}
