#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>


#include <assert.h>


#define MAX_SOURCE_SIZE (0x100000)

#define WIDTH 1280
#define HEIGHT 800

const char image_file1[] = "input1.raw";
const char image_file2[] = "input2.raw";
const int NUM_PIXELS = WIDTH * HEIGHT;
unsigned num_iters = 1;
static unsigned char *v_src1 = 0, *v_src2=0, *v_dst=0;
static int *v_colour = 0;

// Image access without bounds wrapping.
#define PO(image,x,y,W) ((image)[(y)*(W)+(x)])
// Image access with bounds wrapping.
#define P(image,x,y,W,H) ((image)[( (y)>=H ? H-1 : ((y)<0 ? 0:(y)) )*(W)+( (x)>=W ? W-1 : ((x)<0 ? 0 : (x)) )])

#ifndef WINDOW_SIZE
#define WINDOW_SIZE 2
#endif

#define FLOW_SCALING_FACTOR (1.0f/4.0f)

const int l_ncols = 55;
const int l_colorwheel[] = {
  255, 0, 0,
  255, 17, 0,
  255, 34, 0,
  255, 51, 0,
  255, 68, 0,
  255, 85, 0,
  255, 102, 0,
  255, 119, 0,
  255, 136, 0,
  255, 153, 0,
  255, 170, 0,
  255, 187, 0,
  255, 204, 0,
  255, 221, 0,
  255, 238, 0,
  255, 255, 0,
  213, 255, 0,
  170, 255, 0,
  128, 255, 0,
  85, 255, 0,
  43, 255, 0,
  0, 255, 0,
  0, 255, 63,
  0, 255, 127,
  0, 255, 191,
  0, 255, 255,
  0, 232, 255,
  0, 209, 255,
  0, 186, 255,
  0, 163, 255,
  0, 140, 255,
  0, 116, 255,
  0, 93, 255,
  0, 70, 255,
  0, 47, 255,
  0, 24, 255,
  0, 0, 255,
  19, 0, 255,
  39, 0, 255,
  58, 0, 255,
  78, 0, 255,
  98, 0, 255,
  117, 0, 255,
  137, 0, 255,
  156, 0, 255,
  176, 0, 255,
  196, 0, 255,
  215, 0, 255,
  235, 0, 255,
  255, 0, 255,
  255, 0, 213,
  255, 0, 170,
  255, 0, 128,
  255, 0, 85,
  255, 0, 43
};


bool save_image_ppm (const char *outf, unsigned char *image1, int width, int height) {
  FILE *output = fopen (outf, "wb");
  if (output == NULL) {
    printf ("Couldn't open %s for writing!\n", outf);
    return false;
  }
  fprintf(output, "P6\n%d %d\n%d\n", width, height, 255);
  int i,j;
  for (j = 0; j < height; j++) {
    for (i = 0; i < width; i++) {
      // Pixels are in RGB format (and order).
      fwrite(&image1[j*width + i], 1, 3, output);
   }
    }
   fclose (output);
   return true;
}


bool read_image_raw (const char *outf, unsigned char *image1, int width, int height) {
  FILE *input = fopen (outf, "r");
  if (input == NULL) {
    printf ("Couldn't open %s for reading!\n", outf);
    return false;
  }
  int i,j;
  for (j = 0; j < height; j++) {
    for (i = 0; i < width; i++) {
      fscanf (input, "%hhu ", &(image1[j*width+i]));
    }
    fscanf (input, "\n");
  }
  fclose (input);
  return true;
}


#define MAXCOLS 60
void setcols(int *colourwheel, int r, int g, int b, int k) {
  *(colourwheel + k*3 + 0) = r;
  *(colourwheel + k*3 + 1) = g;
  *(colourwheel + k*3 + 2) = b;
}

void makecolourwheel(int* colourwheel, int* ncols) {

  int RY = 15;
  int YG = 6;
  int GC = 4;
  int CB = 11;
  int BM = 13;
  int MR = 6;
  *ncols = RY + YG + GC + CB + BM + MR;
  if (*ncols > MAXCOLS)
    return;
  int i;
  int k = 0;
  for (i = 0; i < RY; i++) setcols(colourwheel, 255, 255*i/RY, 0, k++);
  for (i = 0; i < YG; i++) setcols(colourwheel, 255-255*i/YG, 255, 0, k++);
  for (i = 0; i < GC; i++) setcols(colourwheel, 0, 255, 255*i/GC, k++);
  for (i = 0; i < CB; i++) setcols(colourwheel, 0,	255-255*i/CB, 255, k++);
  for (i = 0; i < BM; i++) setcols(colourwheel, 255*i/BM, 0, 255, k++);
  for (i = 0; i < MR; i++) setcols(colourwheel, 255, 0, 255-255*i/MR, k++);
}



int get_matrix_inv (int* G, float* G_inv) {

  float detG = (float)G[0] * G[3]  - (float)G[1] * G[2];
  if (detG <= 1.0f) {
    return 0;
  }

  float detG_inv = 1.0f / detG;
  G_inv[0] =  G[3] * detG_inv;
  G_inv[1] = -G[1] * detG_inv;
  G_inv[2] = -G[2] * detG_inv;
  G_inv[3] =  G[0] * detG_inv;
  
  return 1;
}

void computeColor (float fx, float fy, unsigned char *pix) {
  float rad = sqrt(fx * fx + fy * fy);
  float a = atan2(-fy, -fx) / (float)M_PI;
  float fk = (a + 1.0f) / 2.0f * (l_ncols-1);
  int k0 = (int)fk;
  
  int col0, col1, col2, col3;
  col0 = *(l_colorwheel + k0*3 + 0);
  col1 = *(l_colorwheel + k0*3 + 1);
  col2 = *(l_colorwheel + k0*3 + 2);
  if (rad > 1) rad = 1; // max at 1
  col0 = 255 - rad * (255 - col0); // increase saturation with radius
  col1 = 255 - rad * (255 - col1); // increase saturation with radius
  col2 = 255 - rad * (255 - col2); // increase saturation with radius
  col3 = 0;
  // *pix = convert_uchar4(col);
  //memcpy(pix, (char*) col0, 2);
  pix[0] = (col0 >> 24) & 0xFF;
  pix[1] = (col1 >> 16) & 0xFF;
  pix[2] = (col2 >> 8) & 0xFF;
  pix[3] = col3 & 0xFF;
}


void optical_flow_for_images (unsigned char* im1, unsigned char* im2,unsigned char* out) {

  #define SHIFT_REG_SIZE ( (WINDOW_SIZE+2) * WIDTH + (WINDOW_SIZE+1) )
  #define RES_REG_SIZE   ( SHIFT_REG_SIZE - WIDTH )
  unsigned char im1_reg[SHIFT_REG_SIZE];
  unsigned char im2_reg[SHIFT_REG_SIZE];
  
  int col_ixix_reg[RES_REG_SIZE];
  int col_ixiy_reg[RES_REG_SIZE];
  int col_iyiy_reg[RES_REG_SIZE];
  int col_deltaK_ix_reg[RES_REG_SIZE];
  int col_deltaK_iy_reg[RES_REG_SIZE];
  
  int sq_ixix_reg[RES_REG_SIZE];
  int sq_ixiy_reg[RES_REG_SIZE];
  int sq_iyiy_reg[RES_REG_SIZE];
  int sq_deltaK_ix_reg[RES_REG_SIZE];
  int sq_deltaK_iy_reg[RES_REG_SIZE];
  
  for (uint i = 0; i < SHIFT_REG_SIZE; i++) {
    im1_reg[i] = 0;
    im2_reg[i] = 0;
  }
  for (uint i = 0; i < RES_REG_SIZE; i++) {
    
    col_ixix_reg[i] = 0;
    col_ixiy_reg[i] = 0;
    col_iyiy_reg[i] = 0;
    col_deltaK_ix_reg[i] = 0;
    col_deltaK_iy_reg[i] = 0;

    sq_ixix_reg[i] = 0;
    sq_ixiy_reg[i] = 0;
    sq_iyiy_reg[i] = 0;
    sq_deltaK_ix_reg[i] = 0;
    sq_deltaK_iy_reg[i] = 0;
  }
  
  int i = 0;
  int j = 0;
  while (j < HEIGHT) {
    for (uint i_shift = 1; i_shift < SHIFT_REG_SIZE; i_shift++) {
      im1_reg[i_shift-1] = im1_reg[i_shift];
      im2_reg[i_shift-1] = im2_reg[i_shift];
    }
    im1_reg[SHIFT_REG_SIZE-1] = PO(im1, i, j, WIDTH);
    im2_reg[SHIFT_REG_SIZE-1] = PO(im2, i, j, WIDTH);
    
    for (uint i_shift = 1; i_shift < RES_REG_SIZE; i_shift++) {
      
      col_ixix_reg[i_shift-1] = col_ixix_reg[i_shift];
      col_ixiy_reg[i_shift-1] = col_ixiy_reg[i_shift];
      col_iyiy_reg[i_shift-1] = col_iyiy_reg[i_shift];
      col_deltaK_ix_reg[i_shift-1] = col_deltaK_ix_reg[i_shift];
      col_deltaK_iy_reg[i_shift-1] = col_deltaK_iy_reg[i_shift];
      
      sq_ixix_reg[i_shift-1] = sq_ixix_reg[i_shift];
      sq_ixiy_reg[i_shift-1] = sq_ixiy_reg[i_shift];
      sq_iyiy_reg[i_shift-1] = sq_iyiy_reg[i_shift];
      sq_deltaK_ix_reg[i_shift-1] = sq_deltaK_ix_reg[i_shift];
      sq_deltaK_iy_reg[i_shift-1] = sq_deltaK_iy_reg[i_shift];
    }
    
    #define IX(P)         ((im1_reg[(P)+1] - im1_reg[(P)-1]) >> 1)
    #define IY(P)         ((im1_reg[(P)+WIDTH] - im1_reg[(P)-WIDTH]) >> 1)
    #define DELTAK(P)     (im1_reg[(P)] - im2_reg[(P)])
    #define IXIX(P)       (IX(P)*IX(P))
    #define IXIY(P)       (IX(P)*IY(P))
    #define IYIY(P)       (IY(P)*IY(P))
    #define DELTAK_IX(P)  (DELTAK(P)*IX(P))
    #define DELTAK_IY(P)  (DELTAK(P)*IY(P))
    
    int deltaK = DELTAK(RES_REG_SIZE-1);
    int cIx = IX(RES_REG_SIZE-1);
    int cIy = IY(RES_REG_SIZE-1);
    
    col_ixix_reg[RES_REG_SIZE-1] = col_ixix_reg[RES_REG_SIZE-1-WIDTH] - IXIX(RES_REG_SIZE-1-WINDOW_SIZE*WIDTH) + cIx * cIx;
    col_ixiy_reg[RES_REG_SIZE-1] = col_ixiy_reg[RES_REG_SIZE-1-WIDTH] - IXIY(RES_REG_SIZE-1-WINDOW_SIZE*WIDTH) + cIx * cIy;
    col_iyiy_reg[RES_REG_SIZE-1] = col_iyiy_reg[RES_REG_SIZE-1-WIDTH] - IYIY(RES_REG_SIZE-1-WINDOW_SIZE*WIDTH) + cIy * cIy;
    col_deltaK_ix_reg[RES_REG_SIZE-1] = col_deltaK_ix_reg[RES_REG_SIZE-1-WIDTH] - DELTAK_IX(RES_REG_SIZE-1-WINDOW_SIZE*WIDTH) + deltaK * cIx;
    col_deltaK_iy_reg[RES_REG_SIZE-1] = col_deltaK_iy_reg[RES_REG_SIZE-1-WIDTH] - DELTAK_IY(RES_REG_SIZE-1-WINDOW_SIZE*WIDTH) + deltaK * cIy;
    
    sq_ixix_reg[RES_REG_SIZE-1] = sq_ixix_reg[RES_REG_SIZE-2] - col_ixix_reg[RES_REG_SIZE-1-WINDOW_SIZE] + col_ixix_reg[RES_REG_SIZE-1];
    sq_ixiy_reg[RES_REG_SIZE-1] = sq_ixiy_reg[RES_REG_SIZE-2] - col_ixiy_reg[RES_REG_SIZE-1-WINDOW_SIZE] + col_ixiy_reg[RES_REG_SIZE-1];
    sq_iyiy_reg[RES_REG_SIZE-1] = sq_iyiy_reg[RES_REG_SIZE-2] - col_iyiy_reg[RES_REG_SIZE-1-WINDOW_SIZE] + col_iyiy_reg[RES_REG_SIZE-1];
    sq_deltaK_ix_reg[RES_REG_SIZE-1] = sq_deltaK_ix_reg[RES_REG_SIZE-2] - col_deltaK_ix_reg[RES_REG_SIZE-1-WINDOW_SIZE] + col_deltaK_ix_reg[RES_REG_SIZE-1];
    sq_deltaK_iy_reg[RES_REG_SIZE-1] = sq_deltaK_iy_reg[RES_REG_SIZE-2] - col_deltaK_iy_reg[RES_REG_SIZE-1-WINDOW_SIZE] + col_deltaK_iy_reg[RES_REG_SIZE-1];
    
    float G_inv[4] = {0.0f, 0.0f, 0.0f, 0.0f};      
    
    float mu[2] = {0, 0};
    int G[4] = {0, 0, 0, 0};
    
    int b_k[2] = {0, 0};
    
    G[0] = sq_ixix_reg[RES_REG_SIZE-1];
    G[1] = sq_ixiy_reg[RES_REG_SIZE-1];
    G[2] = G[1];
    G[3] = sq_iyiy_reg[RES_REG_SIZE-1];
    b_k[0] = sq_deltaK_ix_reg[RES_REG_SIZE-1];
    b_k[1] = sq_deltaK_iy_reg[RES_REG_SIZE-1];
    
    get_matrix_inv (G, G_inv);
    
    float fx=0.0f, fy=0.0f;
    if (j >= (WINDOW_SIZE/2 + 1) && i >= (WINDOW_SIZE/2 + 1) ) {
      fx = G_inv[0] * b_k[0] + G_inv[1] * b_k[1];
      fy = G_inv[2] * b_k[0] + G_inv[3] * b_k[1];
    }
    
    int zj = j - WINDOW_SIZE;
    int zi = i - WINDOW_SIZE;

    if (zi >= 0 && zj >= 0) {
      unsigned char result;
      computeColor (fx * FLOW_SCALING_FACTOR, fy * FLOW_SCALING_FACTOR, &result);
      PO(out, zi, zj, WIDTH) = result;
   }
    
    j = (i+1)>=(WIDTH) ? (j+1) : j;
    i = (i+1)>=(WIDTH) ? 0 : (i+1);
  }
}

int main(int argc, char** argv) {

    printf("Running %d iterations\n", num_iters);


    // Create memory buffers on the device for each vector
    v_src1 = (unsigned char*) malloc(sizeof(unsigned char) * NUM_PIXELS);
    v_src2 = (unsigned char*) malloc(sizeof(unsigned char) * NUM_PIXELS);
    v_dst = (unsigned char*) malloc(sizeof(unsigned char) * NUM_PIXELS);
    v_colour = (int*) malloc(sizeof(int) * MAXCOLS * 3);

    printf("Build colour palette\n");
    int ncols;
    makecolourwheel (v_colour, &ncols);

    printf("Reading input images\n");
    if(!read_image_raw (image_file1, v_src1, WIDTH, HEIGHT)) {
      printf("ERROR: failed to read input1 image\n");
      return -1;
    }
    
    if(!read_image_raw (image_file2, v_src2, WIDTH, HEIGHT)) {
      printf("ERROR: failed to read input1 image\n");
      return -1;
    }
    
    printf("Aplying optical flow...\n");
    optical_flow_for_images(v_src1, v_src2, v_dst);
   
    printf("Writting output image...\n");
    if (!save_image_ppm("out_optical_flow.ppm", v_dst, WIDTH, HEIGHT)) {
      printf("ERROR: failed to write result\n");
      return -1;
    }
    
    free(v_src1);
    free(v_src2);
    free(v_dst);
    free(v_colour);

    printf("DONE\n");

    return 0;

}

