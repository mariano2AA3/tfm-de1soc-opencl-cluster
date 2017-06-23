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
 *       Filename:  Image.c
 *
 *    Description:  Describes the Image struct and supporting functions
 *
 *        Version:  1.0
 *        Created:  10/14/2013 06:09:14 PM
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
#include <tiffio.h>

#include "Image.h"
#include "Resources.h"

/* #####   PROTOTYPES  -  LOCAL TO THIS SOURCE FILE   ############################### */
bool Image_readTiff( Image* pImage, const char* inputFile );
bool Image_readRaw( Image* pImage, const char* inputFile);
bool Image_parseCfg( Image* pImage, const char* cfgFile );
bool Image_writeTiff( Image* pImage, const char* outputFile );
//bool Image_writeRaw( Image* pImage, const char* outputFile );

/* #####   FUNCTION DEFINITIONS  -  EXPORTED FUNCTIONS   ############################ */

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_initialize
 *  Description:  Initializes the Image struct
 * =====================================================================================
 */
bool Image_initialize( Image* pImage )
{
	pImage->height		= 0;
	pImage->width		= 0;
	pImage->depth		= 0;
	pImage->channels	= 0;

	pImage->colorspace	= CSPACE_NONE;
	pImage->interleave	= INTERLEAVE_NONE;

	pImage->pixels		= NULL;

	return true;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_cleanup
 *  Description:  Cleans up the Image struct
 * =====================================================================================
 */
bool Image_cleanup( Image* pImage )
{
	if( pImage->pixels != NULL )
	{
		aligned_free( pImage->pixels );
	}
	return Image_initialize( pImage );
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_read
 *  Description:  Reads in an image from file based on the file type
 * =====================================================================================
 */
bool Image_read( Image* pImage, const char* inputFile )
{
	/*-----------------------------------------------------------------------------
	 *  We read in the image based on the file extension
	 *-----------------------------------------------------------------------------*/
	if( strstr( inputFile, ".raw" ) != NULL || strstr( inputFile, ".RAW" ) != NULL )
	{
		return Image_readRaw( pImage, inputFile );
	}
	else if( strstr( inputFile, ".tif" ) != NULL || strstr( inputFile, ".tiff" ) != NULL )
	{
		return Image_readTiff( pImage, inputFile);
	}
	
	/*-----------------------------------------------------------------------------
	 *  If we didn't find a useable file type, then we cannot read in the image
	 *-----------------------------------------------------------------------------*/
	return false;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_write
 *  Description:  Writes out an image based on the file type
 * =====================================================================================
 */
bool Image_write( Image* pImage, const char* outputFile )
{
	
	/*-----------------------------------------------------------------------------
	 *  We write out the file based on the file extension
	 *-----------------------------------------------------------------------------*/
	if( strstr( outputFile, ".raw" ) != NULL || strstr( outputFile, ".RAW" ) != NULL )
	{
		//return Image_writeRaw( pImage, outputFile );
	}
	else if( strstr( outputFile, ".tif" ) != NULL || strstr( outputFile, ".tiff" ) != NULL )
	{
		return Image_writeTiff( pImage, outputFile );
	}

	/*-----------------------------------------------------------------------------
	 *  If we didn't find a usable file type, then we cannot write out the image
	 *-----------------------------------------------------------------------------*/
	return false;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_scanlineInterleave
 *  Description:  Converts an Image from pixel or channel interleaved to scanline interleaved
 * =====================================================================================
 */
bool Image_scanlineInterleave( Image* pImage )
{
	uchar* temp = NULL;
	uint y = 0, x = 0, chan = 0, color_plane_index;
	if ( pImage->interleave != INTERLEAVE_PIXEL && pImage->interleave != INTERLEAVE_CHANNEL )
	{
		fprintf ( stderr, "Image must be in pixel or channel interleaved form to convert.\n" );
		return false;
	}
	
	temp = (uchar*)aligned_malloc((pImage->depth/8)*pImage->height*pImage->width*pImage->channels);
	switch( pImage->interleave )
	{
	case INTERLEAVE_PIXEL:	
		for ( y = 0; y < pImage->height; y++ )
		{
			for( chan = 0; chan < pImage->channels; chan++ )
			{
				for( x = 0; x < pImage->width; x++ )
				{
					temp[y*pImage->width*pImage->channels + chan*pImage->width + x] = pImage->pixels[y*pImage->width*pImage->channels + x*pImage->channels + chan];
				}
			}
		}
		break;
	case INTERLEAVE_CHANNEL:
		color_plane_index = pImage->height*pImage->width;
		for( y = 0; y < pImage->height; y++ )
		{
			for( chan = 0; chan < pImage->channels; chan++ )
			{
				for( x = 0; x < pImage->width; x++ )
				{
					temp[y*pImage->width*pImage->channels + chan*pImage->width + x] = pImage->pixels[color_plane_index*chan + y*pImage->width + x];
				}
			}
		}
		break;
	default:
		return false;
	}

	aligned_free( pImage->pixels );
	pImage->pixels = temp;
	pImage->interleave = INTERLEAVE_SCANLINE;
	return true;
}
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_pixelInterleave
 *  Description:  Converts an Image from scanline interleaved to pixel interleaved
 * =====================================================================================
 */
bool Image_pixelInterleave( Image* pImage )
{
	uchar* temp = NULL;
	uint y = 0, x = 0, chan = 0;
	if ( pImage->interleave != INTERLEAVE_SCANLINE )
	{
		fprintf ( stderr, "Image must be in scanline interleaved form to convert.\n" );
		return false;
	}
	
	temp = (uchar*)aligned_malloc((pImage->depth/8)*pImage->height*pImage->width*pImage->channels);
	
	for ( y = 0; y < pImage->height; y++ )
	{
		for( chan = 0; chan < pImage->channels; chan++ )
		{
			for( x = 0; x < pImage->width; x++ )
			{
				temp[y*pImage->width*pImage->channels + x*pImage->channels + chan] = pImage->pixels[y*pImage->width*pImage->channels + chan*pImage->width + x];
			}
		}
	}
	aligned_free( pImage->pixels );
	pImage->pixels = temp;
	pImage->interleave = INTERLEAVE_PIXEL;
	return true;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_channelInterleave
 *  Description:  Converts an Image from scanline interleaved to channel interleaved form
 * =====================================================================================
 */
bool Image_channelInterleave( Image* pImage )
{
	uchar* temp = NULL;
	uint y = 0, x = 0, chan = 0, color_plane_index = 0;
	if ( pImage->interleave != INTERLEAVE_SCANLINE ) 
	{
		fprintf ( stderr, "Image must be in scanline interleaved form to convert.\n" );
		return false;
	}
	
	temp = (uchar*)aligned_malloc((pImage->depth/8)*pImage->height*pImage->width*pImage->channels);
	color_plane_index = pImage->height*pImage->width;
	for( y = 0; y < pImage->height; y++ )
	{
		for( chan = 0; chan < pImage->channels; chan++ )
		{
			for( x = 0; x < pImage->width; x++ )
			{
				temp[color_plane_index*chan + y*pImage->width + x] = pImage->pixels[y*pImage->width*pImage->channels + chan*pImage->width + x];
			}
		}
	}

	aligned_free( pImage->pixels );
	pImage->pixels = temp;
	pImage->interleave = INTERLEAVE_CHANNEL;
	return true;

}

/* #####   FUNCTION DEFINITIONS  -  LOCAL TO THIS SOURCE FILE   ##################### */
bool Image_readRaw( Image* pImage, const char* inputFile )
{
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	char* cfgFile 	= NULL;
	char* extension	= NULL;
	int cfgLen	= 0;

	FILE* pRawFile 	= NULL;
	
	int imageBytes	= 0;
	int size 	= 0;
	
	Image_initialize( pImage );
	
	/*-----------------------------------------------------------------------------
	 *  We must generate the file name for the cfg file.  It is assumed that the 
	 *  cfg file will be the same name as the input file, but with .cfg instead of 
	 *  .raw
	 *-----------------------------------------------------------------------------*/
	cfgLen = strlen( inputFile );
	cfgFile = (char*)aligned_malloc( sizeof( char ) * cfgLen + 1 );
	strcpy( cfgFile, inputFile );
	extension = strstr( cfgFile, ".raw" );
	/*-----------------------------------------------------------------------------
	 *  If extension not found, then try .RAW
	 *-----------------------------------------------------------------------------*/
	if( extension == NULL )
	{
		extension = strstr( cfgFile, ".RAW" );
		if( extension == NULL )
		{
			return false;
		}
	}

	/*-----------------------------------------------------------------------------
	 *  Replace the .raw with .cfg
	 *-----------------------------------------------------------------------------*/
	strcpy( extension, ".cfg" );

	
	/*-----------------------------------------------------------------------------
	 *  Open the .cfg file and extract all the details out of it
	 *-----------------------------------------------------------------------------*/
	if( !(Image_parseCfg( pImage, cfgFile )) )
	{
		aligned_free( cfgFile );
		return false;
	}
	aligned_free( cfgFile );

	/*-----------------------------------------------------------------------------
	 *  Read in the RAW pixels based on cfg file
	 *-----------------------------------------------------------------------------*/
	if( (pRawFile = fopen(inputFile, "rb")) == NULL )
	{
		return false;
	}

	imageBytes = pImage->width * pImage->height * pImage->channels;
	
	/*-----------------------------------------------------------------------------
	 *  Validate that the .raw file is the correct length
	 *-----------------------------------------------------------------------------*/
	fseek( pRawFile, 0, SEEK_END );
	size = ftell( pRawFile );
	if( size != imageBytes )
	{
		return false;
	}
	fseek( pRawFile, 0, SEEK_SET );
	pImage->pixels = (uchar*)aligned_malloc( sizeof(uchar) * imageBytes );

	fread( pImage->pixels, 1, imageBytes, pRawFile );
	
	Image_updateSize( pImage );

	return true;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_parseCfg
 *  Description:  Parses a cfg file associated with a raw image
 * =====================================================================================
 */
bool Image_parseCfg( Image* pImage, const char* cfgFile )
{

	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	FILE* pCfgFile	= NULL;
	char name[64];
	char tempChar[8];
	char tempOrder[32];


	/*-----------------------------------------------------------------------------
	 *  Open the cfg file for reading
	 *-----------------------------------------------------------------------------*/
	if( (pCfgFile = fopen( cfgFile, "rb" )) == NULL )
	{
		return false;
	}

	
	/*-----------------------------------------------------------------------------
	 *  Initialize the image incase it hasn't happened yet
	 *-----------------------------------------------------------------------------*/
	Image_initialize( pImage );

	/*-----------------------------------------------------------------------------
	 *  parse the data in the file
	 *-----------------------------------------------------------------------------*/
	while(1)
	{
		if( (fscanf( pCfgFile, "%s", name )) == EOF )
		{
			break;
		}
		fscanf( pCfgFile, "%s", tempChar );
		
		if( strcmp( tempChar, "=" ) != 0 )
		{
			return false;
		}
		if( strcmp( name, "Width") == 0 )
		{
			fscanf( pCfgFile, "%u", &pImage->width );
		}
		else if( strcmp( name, "Length" ) == 0 )
		{
			fscanf( pCfgFile, "%u", &pImage->height );
		}
		else if( strcmp( name, "Number_of_color_planes" ) == 0 )
		{
			fscanf( pCfgFile, "%u", &pImage->channels );
		}
		else if( strcmp( name, "Bit_depth" ) == 0 )
		{
			fscanf( pCfgFile, "%u", &pImage->depth );
		}
		else if( strcmp( name, "Data_order" ) == 0 )
		{
			fscanf( pCfgFile, "%s", tempOrder);

			/*-----------------------------------------------------------------------------
			 *  The raw file must be scanline interleaved to be read in.
			 *-----------------------------------------------------------------------------*/
			if( strcmp( tempOrder, "scanline" ) != 0)
			{
				return false;
			}

		}
	}
	fclose( pCfgFile );
	
	/*-----------------------------------------------------------------------------
	 *  Make sure we have all the information that we need
	 *-----------------------------------------------------------------------------*/
	if( 	pImage->width == 0 	||
		pImage->height == 0	||
		pImage->channels == 0	||
		pImage->depth == 0		)
	{
		return false;
	}
	pImage->interleave = INTERLEAVE_SCANLINE;
	

	/*-----------------------------------------------------------------------------
	 *  Since colorspace is not included in cfg file, we will assume that 3 channels
	 *  is RGB and 4 channels is CMYK
	 *-----------------------------------------------------------------------------*/
	switch( pImage->channels )
	{
		case 3:
			pImage->colorspace = CSPACE_RGB;
			break;
		case 4:
			pImage->colorspace = CSPACE_CMYK;
			break;
		default:
			return false;
	}
	return true;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_readTiff
 *  Description:  Reads in a tiff image from file
 * =====================================================================================
 */
bool Image_readTiff( Image* pImage, const char* inputFile )
{
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	TIFF* inputTiff = NULL;

	int i = 	0;
	int size =	0;
	
	int tempWidth = 	0;
	int tempHeight =	0;
	short tempChannels = 	0;
	short tempDepth = 	0;
	
	short tempInterleave = 	0;	
	short tempColorSpace = 	0;
	short tempCompression = 0;

	Image_initialize( pImage );

	/*-----------------------------------------------------------------------------
	 *  Open the input tiff file
	 *-----------------------------------------------------------------------------*/
	inputTiff = TIFFOpen( inputFile, "r" );
	if( inputTiff == NULL )
	{
		return false;
	}


	/*-----------------------------------------------------------------------------
	 *  Get the information from the tiff file
	 *-----------------------------------------------------------------------------*/
	TIFFGetField( inputTiff, TIFFTAG_IMAGEWIDTH, 		&tempWidth );
	TIFFGetField( inputTiff, TIFFTAG_IMAGELENGTH, 		&tempHeight );
	TIFFGetField( inputTiff, TIFFTAG_SAMPLESPERPIXEL, 	&tempChannels );
	TIFFGetField( inputTiff, TIFFTAG_BITSPERSAMPLE,		&tempDepth );
	TIFFGetField( inputTiff, TIFFTAG_PLANARCONFIG,		&tempInterleave );
	TIFFGetField( inputTiff, TIFFTAG_PHOTOMETRIC, 		&tempColorSpace );
	TIFFGetField( inputTiff, TIFFTAG_COMPRESSION, 		&tempCompression );
	
	/*-----------------------------------------------------------------------------
	 *  Make sure that the values that we get are supported, if not get out of here
	 *-----------------------------------------------------------------------------*/
	if( tempCompression != COMPRESSION_NONE )
	{
		return false;
	}


	/*-----------------------------------------------------------------------------
	 *  If we made it here, then the image is supported so store the information in
	 *  the Image struct
	 *-----------------------------------------------------------------------------*/
	pImage->width = tempWidth;
	pImage->height = tempHeight;
	pImage->channels = tempChannels;
	pImage->depth = tempDepth;

	switch( tempInterleave )
	{
		case PLANARCONFIG_CONTIG:
			pImage->interleave = INTERLEAVE_PIXEL;
			break;
		case PLANARCONFIG_SEPARATE:
			pImage->interleave = INTERLEAVE_CHANNEL;
			break;
		default:
			return false;
	}

	switch( tempColorSpace )
	{
		case PHOTOMETRIC_SEPARATED:
			pImage->colorspace = CSPACE_CMYK;
			break;
		case PHOTOMETRIC_CIELAB:
			pImage->colorspace = CSPACE_LAB;
			break;
		case PHOTOMETRIC_RGB:
		default:
			pImage->colorspace = CSPACE_RGB;
			break;
	}
	

	/*-----------------------------------------------------------------------------
	 *  Allocate the memory for the pixels of the image
	 *-----------------------------------------------------------------------------*/
	size =((int)tempDepth / 8) * tempHeight * tempWidth * (int)tempChannels;
	pImage->pixels = (uchar*)aligned_malloc( size );
	if( pImage->pixels == NULL )
	{
		return false;
	}


	/*-----------------------------------------------------------------------------
	 *  Read in that image
	 *-----------------------------------------------------------------------------*/
	for( i = 0; i < tempHeight; i++ )
	{
		if( TIFFReadScanline( 	inputTiff, 
					&pImage->pixels[i * tempWidth * tempChannels], 
					i,
					0 ) < 0 )
		{
			break;
		}
	}
	Image_updateSize( pImage );

	return true;

}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_writeTiff
 *  Description:  Writes the Image struct to a tiff file
 * =====================================================================================
 */
bool Image_writeTiff( Image* pImage, const char* outputFile )
{
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	TIFF* pOutputFile = NULL;

	uint i = 0;

	/*-----------------------------------------------------------------------------
	 *  Open the output tiff
	 *-----------------------------------------------------------------------------*/
	pOutputFile = TIFFOpen( outputFile, "wb" );
	/*-----------------------------------------------------------------------------
	 *  Verify that we can write this Image to tiff
	 *-----------------------------------------------------------------------------*/
	if( pImage->interleave != INTERLEAVE_PIXEL )
	{
		Image_pixelInterleave( pImage );
	}
	/*-----------------------------------------------------------------------------
	 *  Set the TIFF parameters
	 *-----------------------------------------------------------------------------*/
	TIFFSetField( pOutputFile, TIFFTAG_IMAGEWIDTH,			pImage->width );
	TIFFSetField( pOutputFile, TIFFTAG_IMAGELENGTH,			pImage->height );
	TIFFSetField( pOutputFile, TIFFTAG_SAMPLESPERPIXEL,		pImage->channels );
	TIFFSetField( pOutputFile, TIFFTAG_BITSPERSAMPLE,		pImage->depth );
	TIFFSetField( pOutputFile, TIFFTAG_PLANARCONFIG,		PLANARCONFIG_CONTIG );
	TIFFSetField( pOutputFile, TIFFTAG_ROWSPERSTRIP,		1 );
	if( pImage->channels == 4)
	{
		TIFFSetField( pOutputFile, TIFFTAG_PHOTOMETRIC,		PHOTOMETRIC_SEPARATED );
	
	}
	else if( pImage->channels == 3 )
	{
		TIFFSetField( pOutputFile, TIFFTAG_PHOTOMETRIC,		PHOTOMETRIC_RGB );
	}	
	
	for( i = 0; i < pImage->height; i++ )
	{
		if( TIFFWriteScanline( pOutputFile, &pImage->pixels[i * pImage->width * pImage->channels * (pImage->depth / 8 )], i , 0 ) < 0 )
		{
			break;
		}
	}
	TIFFClose( pOutputFile );
	
	return true;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  Image_updateSize
 *  Description:  Updates the number of bytes in the image
 * =====================================================================================
 */
bool Image_updateSize( Image* pImage )
{
	uint tempSize = pImage->width * pImage->height * pImage->channels * (pImage->depth/8);
	pImage->size = tempSize;

	return true;
}
