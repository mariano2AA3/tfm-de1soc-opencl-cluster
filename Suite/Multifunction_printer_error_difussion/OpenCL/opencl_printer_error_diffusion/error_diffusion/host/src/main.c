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
 *       Filename:  main.c
 *
 *    Description:  OpenCL Error Diffusion testing application
 *
 *        Version:  1.0
 *        Created:  10/21/2013 04:41:32 PM
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
#include <unistd.h> // readlink, chdir

#include "Benchmark.h"
#include "EDState.h"
#include "ErrorDiffusion_OpenCL.h"
#include "ErrorDiffusion_C.h"
#include "Image.h"
#include "Types.h"


/* #####   PROTOTYPES  -  LOCAL TO THIS SOURCE FILE   ############################### */
bool parseArguments( int argc, char** argv, EDState* edState);
bool compare_Images( Image* pImage1, Image* pImage2 );
bool setCwdToExeDir();

/* #####   FUNCTION DEFINITIONS  -  LOCAL TO THIS SOURCE FILE   ##################### */

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  main
 *  Description:  main function 
 * =====================================================================================
 */
int main( int argc, char* argv[] )
{
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	EDState 	edState;
	Benchmark	edBenchmark[1];	// 2

	if( parseArguments( argc, argv, &edState ) == false )
	{
		fprintf( stderr, "Usage: ErrorDiffusion -i INPUT.tif -o OUTPUT.tif -p OPENCL_PROGRAM.aocx [OPTIONS]\n" );
		fprintf( stderr, "\t-v\t\tverbose\n" );
		fprintf( stderr, "\t-r\t\treport\n" );
		return EXIT_FAILURE;
	}

	// set current dir to execution dir (in case executable was called from another directory)
	// will help finding files
	if(!setCwdToExeDir()) {
		return 0;
	}

	if( edState.report == true )
	{
		Benchmark_init( &edBenchmark[0], "OpenCL" );
//		Benchmark_init( &edBenchmark[1], "C" );
	}

	/*-----------------------------------------------------------------------------
	 *  Set up OpenCL Environment
	 *-----------------------------------------------------------------------------*/
	if( edState.verbose )
	{
		fprintf( stdout, "Initializing OpenCL Environment\n" );
	}
	if( OpenCL_Environment_init( &edState.environment, edState.oclProgram ) != true )
	{
		fprintf( stderr, "Failed to initialize OpenCL environment.\n" );
		return EXIT_FAILURE;
	}
	if( edState.verbose )
	{
		fprintf( stdout, "OpenCL Environement initialized.\n" );
	}


	/*-----------------------------------------------------------------------------
	 *  Load the OpenCL Kernels
	 *-----------------------------------------------------------------------------*/	
	if( edState.verbose )
	{
		fprintf( stdout, "Loading OpenCL kernels into runtime.\n" );
	}
	if( OpenCL_Kernel_init( &edState.kernels[0], &edState.environment,  "errorDiffusion" ) != true )
	{
		fprintf( stderr, "Failed to load OpenCL kernel\n" );
	}

	/*-----------------------------------------------------------------------------
	 *  Load the image 
	 *-----------------------------------------------------------------------------*/
  	if( edState.verbose )
	{
		fprintf( stdout, "Loading %s from file.\n", edState.iImage );
	}
	if( Image_read( &edState.image, edState.iImage ) != true )
	{
		fprintf( stderr, "Failed to read %s from file.\n", edState.iImage );
		return EXIT_FAILURE;
	}
        
	if( edState.verbose )
	{
		fprintf( stdout, "Loading %s from file for C comparison.\n", edState.iImage );
	}
	if( Image_read( &edState.cImage, edState.iImage ) != true )
	{
		fprintf( stderr, "Failed to read %s from file.\n", edState.iImage );
		return EXIT_FAILURE;
	}
        

	/*-----------------------------------------------------------------------------
	 *  Place the image in a OpenCL Job
	 *-----------------------------------------------------------------------------*/
  	if( edState.verbose )
	{
		fprintf( stdout, "Preparing OpenCL Job.\n" );
	}
	if( OpenCL_Job_init( 	&edState.job, 
				&edState.environment, 
				&edState.image, 
				sizeof(Image),
				(void **)&edState.image.pixels,
				&edState.image.size ) != true )
	{
		fprintf( stderr, "Failed to configure OpenCL Job.\n" );
		return EXIT_FAILURE;
	}
	/*-----------------------------------------------------------------------------
	 *  Perform Error diffusion on the images using OpenCL
	 *-----------------------------------------------------------------------------*/
 	if( edState.verbose )
	{
		fprintf( stdout, "Performing OpenCL Error Diffusion\n" );
	}
	if( edState.report )
	{
		Benchmark_start( &edBenchmark[0] );
	}
 	if( ErrorDiffusion_OpenCL( &edState.kernels[0], &edState.job ) != true )
	{
		fprintf( stderr, "Failed to perform OpenCL  Error Diffusion\n" );
		return EXIT_FAILURE;
	}
	if( edState.report )
	{
		Benchmark_stop( &edBenchmark[0] );
	}
	
	/*-----------------------------------------------------------------------------
	 *  Perform C Error diffusion so we can compare
	 *-----------------------------------------------------------------------------*/

	if( edState.verbose )
	{
		fprintf( stdout, "Performing C Error Diffusion.\n" );
	}
	if( edState.report )
	{
		Benchmark_start( &edBenchmark[1] );
	}
	if( ErrorDiffusion_C( &edState.cImage ) != true )
	{
		fprintf( stderr, "Failed to perform C Error Diffusion.\n" );
		return EXIT_FAILURE;
	}
	if( edState.report )
	{
		Benchmark_stop( &edBenchmark[1] );
	}
	
	/*-----------------------------------------------------------------------------
	 *  Compare the OpenCL and C results
	 *-----------------------------------------------------------------------------*/
/*
	if( edState.verbose )
	{
		fprintf( stdout, "Comparing C and OpenCL Results.\n" );
	}
	if( compare_Images( &edState.image, &edState.cImage ) != true )
	{
		fprintf( stderr, "C Image does not match OpenCL Image.\n" );
		fprintf( stderr, "FAILED\n");
	}
	else
	{
		fprintf( stdout, "C and OpenCL Images match.\n" );
		fprintf( stdout, "PASSED\n");
	}
*/
	/*-----------------------------------------------------------------------------
	 *  Write the image to a tif file for viewing
	 *-----------------------------------------------------------------------------*/
 	if( edState.verbose )
	{
		fprintf( stdout, "Writing %s to file.\n", edState.oImage );
	}
	if( edState.oImage != NULL )
	{
		if( Image_write( &edState.image, edState.oImage ) != true )
		{
			fprintf( stderr, "Failed to write image %s.\n", edState.oImage );
			return EXIT_FAILURE;
		}
	}

	if( edState.ocImage != NULL )
	{
		if( Image_write( &edState.cImage, edState.ocImage ) != true )
		{
			fprintf( stderr, "Failed to write image %s.\n", edState.ocImage );
			return EXIT_FAILURE;
		}
	}

	

	/*-----------------------------------------------------------------------------
	 *  Perform cleanup
	 *-----------------------------------------------------------------------------*/
	if( edState.verbose )
	{
		fprintf( stdout, "Performing clean up operations.\n" );
	}
	if( OpenCL_Job_cleanup( &edState.job, &edState.environment ) != true )
	{
		fprintf( stderr, "OpenCL Job clean up failed.\n" );
		return EXIT_FAILURE;
	}
	if( OpenCL_Environment_cleanup( &edState.environment ) != true )
	{
		fprintf( stderr, "OpenCL Environment clean up failed.\n" );
		return EXIT_FAILURE;
	}
	if( Image_cleanup( &edState.image ) != true )
	{
		fprintf( stderr, "Image clean up failed.\n" );
		return EXIT_FAILURE;
	}
	/*-----------------------------------------------------------------------------
	 *  If we are reporting, then generate a report
	 *-----------------------------------------------------------------------------*/
	if( edState.report == true )
	{
		Benchmark_report( edBenchmark, 1);	// 2
	}
	return EXIT_SUCCESS;
}

bool parseArguments( int argc, char** argv, EDState* edState )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	int i = 0;
	
	/*-----------------------------------------------------------------------------
	 *  Initialize the edState variable
	 *-----------------------------------------------------------------------------*/
	edState->iImage = 	NULL;
	edState->oImage = 	NULL;
	edState->ocImage = 	NULL;
	edState->oclProgram = 	NULL;

	edState->verbose =	false;
	edState->report =	false;

	/*-----------------------------------------------------------------------------
	 *  Parse through the command line arguments
	 *-----------------------------------------------------------------------------*/
	for( i = 1; i < argc; i++ )
	{
		if( strcmp( argv[i], "-i" ) == 0 )
		{
			edState->iImage = argv[++i];
		}
		else if( strcmp( argv[i], "-o" ) == 0 )
		{
			edState->oImage = argv[++i];
		}
		else if( strcmp( argv[i], "-c" ) == 0 )
		{
			edState->ocImage = argv[++i];
		}
		else if( strcmp( argv[i], "-p" ) == 0 )
		{
			edState->oclProgram = argv[++i];
		}
		else if( strcmp( argv[i], "-v" ) == 0 )
		{
			edState->verbose = true;
		}
		else if( strcmp( argv[i], "-r" ) == 0 )
		{
			edState->report = true;
		}
		else
		{
			return false;
		}
	}

	/*-----------------------------------------------------------------------------
	 *  Ensure that all variables that need to be set are
	 *-----------------------------------------------------------------------------*/
	if( edState->iImage == NULL ) 
	{
		return false;
	}
	return true;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  compare_Images
 *  Description:  Compares two images, returns true if identical, false otherwise
 * =====================================================================================
 */
bool compare_Images( Image* pImage1, Image* pImage2 )
{
	uint i = 0;
	uchar* pixel1 = NULL;
	uchar* pixel2 = NULL;

	if(	pImage1->height != pImage2->height 		||
		pImage1->width != pImage2->width		||
		pImage1->size != pImage2->size 			||
		pImage1->depth != pImage2->depth		||
		pImage1->channels != pImage2->channels		||
		pImage1->colorspace != pImage2->colorspace	||
		pImage1->interleave != pImage2->interleave		)
	{
		return false;
	}
	pixel1 = pImage1->pixels;
	pixel2 = pImage2->pixels;
	for( i = 0; i < pImage1->size; i++ )
	{
		if( *(pixel1) != *(pixel2))
		{
			fprintf( stderr, "\tCompare Failed!\n");
			fprintf( stderr, "\tLocation: %d\t Channel: %d\n", i/4, i%4);
			fprintf( stderr, "\tByte: %d\tPixel1: %d\tPixel2: %d\n", i, *(pixel1), *(pixel2) );
			return false;
		}
		pixel1++;
		pixel2++;
	}	
	fprintf( stderr, "\tCompare Passed!\n");
	return true;
}


// Sets the current working directory to be the same as the directory
// containing the running executable.
// Just like in AOCL_Utils.h but a pure C function
bool setCwdToExeDir() {
	// Get path of executable.
	char path[256];
	if(readlink("/proc/self/exe", path, sizeof(path)/sizeof(path[0])) < 0) {
		return false;
	}

	// Find the last '\' or '/' and terminate the path there; it is now
	// the directory containing the executable.
	size_t i;
	for(i = strlen(path) - 1; i > 0 && path[i] != '/' && path[i] != '\\'; --i);
	path[i] = '\0';

	// Change the current directory.
	chdir(path);

	return true;
}

