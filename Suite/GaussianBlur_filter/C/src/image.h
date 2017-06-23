#ifndef IMAGE_H
#define IMAGE_H

#include "filter.h"

typedef struct {
	unsigned char R;
	unsigned char G;
	unsigned char B;
} pixel;


// Loads an .ppm image from a given file
pixel* image_load(const char *image_name, char* header, int* width, int* height, int* color_depth);

// Writes the given image to the "image->image_name" file
int image_write(pixel* image, const char *file_name, const char *header, const int width, const int height, const int color_depth);

// Free
void image_free(pixel* image, const int width, const int height);

// Apply a filter to the image
// pixel** apply_filter(pixel** original, double** filter, int radius, int width, int height);
void apply_filter(pixel* original, pixel* result, double* filter, int radius, int width, int height);

#endif /*IMAGE_H*/
