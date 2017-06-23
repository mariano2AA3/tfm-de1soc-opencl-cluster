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
 *       Filename:  ErrorDiffusion_C.c
 *
 *    Description:  Error Diffusion C Kernel
 *
 *        Version:  1.0
 *        Created:  11/18/2013 05:26:29 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */

/* #####   HEADER FILE INCLUDES   ################################################### */
#include "ErrorDiffusion_C.h"
#include "Resources.h"

#include <stdio.h>
/* #####   MACROS  -  LOCAL TO THIS SOURCE FILE   ################################### */
#define BUFFER_OFFSET	4
#define HALFTONE_VALUE	0x7F

/* #####   FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS   ############################ */
bool ErrorDiffusion_C( Image* pImage )
{

	/*-----------------------------------------------------------------------------
	 *  Image Parameters
	 *-----------------------------------------------------------------------------*/
	uint height 	= pImage->height;
	uint width 	= pImage->width;
	uint nChannels 	= pImage->channels;
	
	uint byteWidth  = width*nChannels;

	uint eBufferSize = (width + BUFFER_OFFSET + 1)*nChannels;
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	uchar* pPixel 		= NULL;
	
	signed char* errorBuffer 	= NULL;
	signed char* errorCell	= NULL;
	
	signed int oPixel		= 0;
	signed int nPixel		= 0;
	signed char error	= 0;

	
	uint i			= 0;
	uint j			= 0;
	
	/*-----------------------------------------------------------------------------
	 *  Allocate space for the error buffer
	 *-----------------------------------------------------------------------------*/
	errorBuffer = (signed char*)aligned_malloc( sizeof( signed char ) * eBufferSize ); 
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

	aligned_free( errorBuffer );
	return true;
}


