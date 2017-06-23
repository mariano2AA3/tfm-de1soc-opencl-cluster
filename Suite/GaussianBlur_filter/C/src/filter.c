#include "filter.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>


double gauss_2d(int x, int y, double sigma) {
	
	double result = 1.0 / (2 * PI * sigma * sigma);
	result *= exp(-(x*x+y*y)/(2 * sigma * sigma));
	
	
	return result;
}

double* filter_create_gauss(int radius, double sigma) {

	//Used for iterations
	int i, j;

	//The matrix width and height
	int dim = 2*radius+1;

	//Alocate mem for the matrix
	double* filter = (double*) malloc(sizeof(double) * dim * dim);

	//Calculate
	double sum = 0.0, sum_old= 0.0;
	double g = 0.0;
	
	for(i = -radius; i <= radius; i++)
		for(j = -radius; j <= radius; j++) {
			filter[(j+radius) + (i+radius) * dim] = gauss_2d(j, i, sigma);
			sum += filter[ (j+radius) + (i+radius) * dim];
		}


	//Correct so that the sum of all elements ~= 1
	for(i = 0; i < 2*radius+1; i++) {
		for(j = 0; j < 2*radius+1; j++) {
			filter[j + i * dim] /= sum;
		}
	}

	return filter;
}


void filter_print(double* filter, const int radius) {
	
	int dim = 2*radius+1, i, j;

	printf("FILTER: \n");

	for(i = 0; i < dim; i++) {
		for(j = 0; j < dim; j++) 
			printf("\t%lf ", filter[j + i * dim]);
		printf("\n");
	}
}


void filter_free(double** filter, int radius) {

	//Free matrix
	int dim=2*radius+1, i;
	for(i = 0; i < dim; i++)
		free(filter[i]);
	
	//Free filter
	free(filter);
}
