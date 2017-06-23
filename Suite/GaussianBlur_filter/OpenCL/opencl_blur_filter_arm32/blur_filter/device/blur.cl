
// #include "../host/inc/defines.h"

typedef struct {
  unsigned char R;
  unsigned char G;
  unsigned char B;
} pixel;

// Sobel filter kernel
// frame_in and frame_out are different buffers. Specify restrict on
// them so that the compiler knows they do not alias each other.
__kernel
void blur(
	global pixel* restrict original, 
	global pixel* restrict result,
	global double* restrict filter, 
	const int radius, 
	const int width, 
	const int height)
{

  int x, y;
  int dim = 2*radius+1;

  for(y = 0; y < height; y++) {
     for(x = 0; x < width; x++) {

	if( x < radius || y < radius || x >= width-radius || y >= height-radius) {
		result[x + y * width] = original[x + y * width];
		continue;
	}

	int i, j;
	pixel res;
	res.R = res.G = res.B = 0;
	double fil;

	for(i = -radius; i <= radius; i++) 
		for(j = -radius; j <= radius; j++) {
   			fil = filter[(j+radius) + (i+radius) * dim];
			res.R += fil * original[(x+j) + (y+i) * width].R;
			res.G += fil * original[(x+j) + (y+i) * width].G;
			res.B += fil * original[(x+j) + (y+i) * width].B;
		}
			
		result[x + y * width].R = res.R;
		result[x + y * width].G = res.G;
		result[x + y * width].B = res.B;
	}
  }

}
