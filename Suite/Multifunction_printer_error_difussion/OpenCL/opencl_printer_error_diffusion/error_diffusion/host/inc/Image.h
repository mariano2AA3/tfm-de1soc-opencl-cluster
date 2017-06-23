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
 *       Filename:  Image.h
 *
 *    Description:  Describes the Image struct and supporting functions
 *
 *        Version:  1.0
 *        Created:  10/14/2013 05:49:54 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jared Bold (), jared.bold@hcl.com
 *   Organization:  
 *
 * =====================================================================================
 */

#ifndef  Image_INC
#define  Image_INC
/* #####   HEADER FILE INCLUDES   ################################################### */
#include "Types.h"

/* #####   EXPORTED DATA TYPES   #################################################### */

/*-----------------------------------------------------------------------------
 *  Enum: Colorspace
 *  Description: Describes the colorspace of an image
 *-----------------------------------------------------------------------------*/
typedef enum
{
	CSPACE_NONE,
	CSPACE_RGB,
	CSPACE_LAB,
	CSPACE_CMYK
}Colorspace;

/*-----------------------------------------------------------------------------
 *  Enum: Interleave
 *  Description: Describes the interleave of the image
 *-----------------------------------------------------------------------------*/
typedef enum
{
	INTERLEAVE_NONE,
	INTERLEAVE_PIXEL,
	INTERLEAVE_SCANLINE,
	INTERLEAVE_CHANNEL
}Interleave;

/*-----------------------------------------------------------------------------
 *  Struct: Image
 *  Description: Describes an image
 *-----------------------------------------------------------------------------*/
typedef struct
{
	uint 		height;
	uint 		width;
	uint		size;                   /* The size of the image in bytes */
	
	uint 		depth;
	uint 		channels;

	Colorspace 	colorspace;
	Interleave 	interleave;

	uchar*		pixels;
}Image;

/* #####   EXPORTED FUNCTION DECLARATIONS   ######################################### */
bool Image_initialize( Image* pImage );          /* Initializes the Image */
bool Image_cleanup( Image* pImage );            /* Cleans up the Image */

bool Image_read( Image* pImage, const char* inputFile ); /* Reads in an image */
bool Image_write( Image* pImage, const char* outputFile ); /* Writes an image */

bool Image_updateSize( Image* pImage );

bool Image_scanlineInterleave( Image* image );   /* Converts an image to scanline interleaved */
bool Image_pixelInterleave( Image* image);      /* Converts an image to pixel interleaved */
bool Image_channelInterleave( Image* image);    /* Converts an image to channel interleaved */
#endif   /* ----- #ifndef Image_INC  ----- */
