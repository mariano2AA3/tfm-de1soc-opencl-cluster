////////////////////////Local Marcos/Defines////////////////
#define MAX_IMAGE_WIDTH 	5100
#define MAX_IMAGE_HEIGHT	6600

#define BUFFER_OFFSET		4

#define ERROR_HALF		5
#define ERROR_FOURTH		4
#define ERROR_EIGHTH		3
#define ERROR_SIXTEENTH		2	
#define ERROR_THIRTYSECOND1	1
#define ERROR_THIRTYSECOND2	0


#define HALFTONE_VALUE		0x7F
#define BUFFER_MAX_WIDTH	MAX_IMAGE_WIDTH


/*************************************************************
 Kernel:	errorDiffusion
 Parameters:	__global uchar4* pixels	-	Pointer to pixel interleaved image data
 		uint height -			The height of the image in pixels
 		uint width - 			The width of the image in pixels
 		uint channels - 		The number of channels (UNUSED)
 
 Description:
 	Performs modified floyd-steinberg error diffusion, inplace,
 	on the pixel data using the follow kernel
 	
 		X	X	X	X	O	1/2
 		1/32	1/32	1/16	1/8	1/4	
 				
***************************************************************/
__kernel void errorDiffusion(__global uchar4* pixels, uint height, uint width, uint channels )
{
	/*-----------------------------------------------------------------------------
	 *  Image Parameters
	 *-----------------------------------------------------------------------------*/
	uint nPixels	= height * width;
	
	/*-----------------------------------------------------------------------------
	 *  Variables
	 *-----------------------------------------------------------------------------*/
	char4 errorBuffer[BUFFER_MAX_WIDTH];
	char4 temp;

	int4 oPixel		= 0;
	int4 nPixel		= 0;
	
	char4 error		= 0;
	
	char4 error2 		= 0;
	char4 error4		= 0;
	char4 error8		= 0;
	char4 error16		= 0;
	char4 error321		= 0;
	char4 error322		= 0;
	
	char4 accumError	= 0;
	
	uint i			= 0;
	uint row		= 0;
	uint col		= 0;
		
	#pragma unroll
	for( int index = 0; index < BUFFER_MAX_WIDTH; index++ )
	{
		errorBuffer[index] = 0;
	}

	for( i = 0; i < nPixels; i++ )
	{	
		
		if( col == BUFFER_MAX_WIDTH )
		{
			row++;
			col = 0;
		}		
		/**********************************************************************
		  * Grab the accumulated error from the error shift register
		  *********************************************************************/
		accumError = errorBuffer[BUFFER_OFFSET];
		
		oPixel = 	convert_int4( pixels[i] );
		oPixel +=	convert_int4( accumError );
		
		(oPixel.x > HALFTONE_VALUE)?(nPixel.x = 0xFF):(nPixel.x = 0x00);
		(oPixel.y > HALFTONE_VALUE)?(nPixel.y = 0xFF):(nPixel.y = 0x00);
		(oPixel.z > HALFTONE_VALUE)?(nPixel.z = 0xFF):(nPixel.z = 0x00);
		(oPixel.w > HALFTONE_VALUE)?(nPixel.w = 0xFF):(nPixel.w = 0x00);
		
		pixels[i] = convert_uchar4(nPixel);
				
		error = convert_char4(oPixel - nPixel);
		
		error2 		= ( error >> (char4)1 );
		error4 		= ( error >> (char4)2 );
		error8 		= ( error >> (char4)3 );
		error16		= ( error >> (char4)4 );
		error321	= ( error >> (char4)5 );
		error322	= ( error >> (char4)5 );
		
		if( col < MAX_IMAGE_WIDTH-1 )
		{
			errorBuffer[ERROR_HALF] 	+= error2;		
		}
		
		errorBuffer[ERROR_FOURTH] 	= error4;
			
		if( col > 0 )
		{
			errorBuffer[ERROR_EIGHTH] 	+= error8;
		}
		if( col > 1 )
		{
			errorBuffer[ERROR_SIXTEENTH] 	+= error16;
		}
		if( col > 2 )
		{
			errorBuffer[ERROR_THIRTYSECOND1]+= error321;
		}
		if( col > 3 )
		{
			errorBuffer[ERROR_THIRTYSECOND2]+= error322;
		}		
		/*************************************************************************
		  * Lets shift that error register
		 *************************************************************************/
		temp = errorBuffer[0];
		#pragma unroll
		for( int index = 1; index < BUFFER_MAX_WIDTH; index++)
		{
			errorBuffer[index-1] = errorBuffer[index];
		}
		errorBuffer[BUFFER_MAX_WIDTH-1] = temp;
		col++;
	}
}

