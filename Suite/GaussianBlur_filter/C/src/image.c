#include "image.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

pixel* image_load(const char *image_name, char* header, int* width, int* height, int* color_depth) {
	
	//Open file
	FILE *file = fopen(image_name, "r");
	if(!file)
		return NULL;

	//Read image info
	fscanf(file, "%s", header);
	fscanf(file, "%d %d %d", width, height, color_depth);

	//Alocate memory for pixels
	/*
	pixel** pixels = (pixel**) malloc(*height * sizeof(pixel*));
	int i, j;
	for(i = 0; i < *height; i++)
		pixels[i] = (pixel*) malloc(*width * sizeof(pixel));
	*/
	pixel* pixels = (pixel*)malloc(sizeof(pixel) * *width * *height);
	int i,j;
	//Read pixels
	for(i = 0; i < *height; i++)
		for(j = 0; j < *width; j++)
			//fscanf(file, "%c%c%c", &(pixels[i][j].R), &(pixels[i][j].G), &(pixels[i][j].B));
			fscanf(file, "%c%c%c", &(pixels[j + i * *width].R), &(pixels[j + i * *width].G), &(pixels[j + i * *width].B));

	//Close file
	fclose(file);

	return pixels;
}

int image_write(pixel* pixels, const char *file_name, const char *header, const int width, const int height, const int color_depth) {
	
	//Open file
	FILE *file = fopen(file_name, "w");
	if(!file)
		return 0;
	
	//Write image info
	fprintf(file, "%s\n%d %d\n%d", header, width, height, color_depth);

	//Write pixels
	int i, j;
	for(i = 0; i < height; i++)
		for(j = 0; j < width; j++)
			//fprintf(file, "%c%c%c", pixels[i][j].R, pixels[i][j].G, pixels[i][j].B);
			fprintf(file, "%c%c%c", pixels[j + i * width].R, pixels[j + i * width].G, pixels[j + i * width].B);

	//Write EOF
	fprintf(file, "%d", EOF);

	//Close file
	fclose(file);

	return 1;
}


void image_free(pixel* image, const int width, const int height) {
	
	//Free pixels
	free(image);
}



void apply_filter(pixel* original, pixel* result, double* filter, int radius, int width, int height) {
	
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
