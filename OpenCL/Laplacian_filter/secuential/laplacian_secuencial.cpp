#define NOMINMAX // so that windows.h does not define min/max macros


#include <iostream>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <math.h>
#include <algorithm>


unsigned int COLS = 800;
unsigned int ROWS = 400;
unsigned int thresh = 128;

unsigned int *input = NULL;
unsigned int *output = NULL;

int *Gx = NULL;// = {-1, -1, -1, -1, 8, -1, -1, -1, -1};
int *Gy = NULL;// = {-1,  0,  1, -2, 0,  2, -1,  0, -1};


std::string filter_type;
std::string imageFilename;


void laplacian(unsigned int* frame_in, unsigned int* frame_out, const int iterations, int* Gx) {
    
    // Pixel buffer of 2 rows and 3 extra pixels
    int rows[2 * COLS + 3];

    // The initial iterations are used to initialize the pixel buffer.
    int count = -(2 * COLS + 3);
    while (count != iterations) {
        // Each cycle, shift a new pixel into the buffer.
        // Unrolling this loop allows the compile to infer a shift register.
        for (int i = COLS * 2 + 2; i > 0; --i) {
            rows[i] = rows[i - 1];
        }
        rows[0] = count >= 0 ? frame_in[count] : 0;

        int x_dir = 0;
       // int y_dir = 0;

        // With these loops unrolled, one convolution can be computed every
        // cycle.
        
        for (int i = 0; i < 3; ++i) {
        
            for (int j = 0; j < 3; ++j) {
                unsigned int pixel = rows[i * COLS + j];
                unsigned int b = pixel & 0xff;
                unsigned int g = (pixel >> 8) & 0xff;
                unsigned int r = (pixel >> 16) & 0xff;

                // RGB -> Luma conversion approximation
                // Avoiding floating point math operators greatly reduces
                // resource usage.
                unsigned int luma = r * 66 + g * 129 + b * 25;
                luma = (luma + 128) >> 8;
                luma += 16;

                x_dir += luma * Gx[j + i * 3];
               // y_dir += luma * Gy[j + i * 3];
            }
        }


        int temp = abs(x_dir);// + abs(y_dir);
        unsigned int clamped;
        if (temp > thresh) {
            clamped = 0xffffff;
        } else {
            clamped = 0;
        }

        if (count >= 0) {
            frame_out[count] = clamped;
        }
        count++;
    }
}



    
  


bool parse_ppm(const char *filename, const unsigned int width, const unsigned int height, unsigned char *data) {
  FILE *fp = NULL;
#ifdef _WIN32
  errno_t err;
  if ((err = fopen_s(&fp, filename, "rb")) != 0)
#else
  if ((fp = fopen(filename, "rb")) == 0)
#endif
  {
    if (fp) { fclose(fp); }
    std::cerr << "Error: failed to load '" << filename << "'" << std::endl;
    return false;
  }

  const size_t headerSize = 0x40;
  char header[headerSize];
  if ((fgets(header, headerSize, fp) == NULL) && ferror(fp)) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: '" << filename << "' is not a valid PPM image" << std::endl;
    return false;
  }

  if (strncmp(header, "P6", 2) != 0) {
    std::cerr << "Error: '" << filename << "' is not a valid PPM image" << std::endl;
    return false;
  }

  int i = 0;
  unsigned int maxval = 0;
  unsigned int w = 0;
  unsigned int h = 0;

  while (i < 3) {
    if ((fgets(header, headerSize, fp) == NULL) && ferror(fp)) {
      if (fp) { fclose(fp); }
      std::cerr << "Error: '" << filename << "' is not a valid PPM image" << std::endl;
      return false;
    }
    // Skip comments
    if (header[0] == '#') continue;
#ifdef _WIN32
    if (i == 0) {
      i += sscanf_s(header, "%u %u %u", &w, &h, &maxval);
    } else if (i == 1) {
      i += sscanf_s(header, "%u %u", &h, &maxval);
    } else if (i == 2) {
      i += sscanf_s(header, "%u", &maxval);
    }
#else
    if (i == 0) {
      i += sscanf(header, "%u %u %u", &w, &h, &maxval);
    } else if (i == 1) {
      i += sscanf(header, "%u %u", &h, &maxval);
    } else if (i == 2) {
      i += sscanf(header, "%u", &maxval);
    }
#endif
  }

  if (maxval == 0) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: maximum color value must be greater than 0" << std::endl;
    return false;
  }
  if (maxval > 255) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: parser only supports 1 byte value PPM images" << std::endl;
    return false;
  }

  if (w != width) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: expected width of " << width
          << " pixels, but file contains image of width "
          << w << " pixels" << std::endl;
    return false;
  }

  if (h != height) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: expected height of " << height
          << " pixels, but file contains image of height "
          << h << " pixels" << std::endl;
    return false;
  }

  unsigned char *raw = (unsigned char *)malloc(sizeof(unsigned char) * width * height * 3);
  if (!raw) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: could not allocate data buffer" << std::endl;
    return false;
  }

  if (fread(raw, sizeof(unsigned char), width * height * 3, fp) != width * height * 3) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: invalid image data" << std::endl;
    return false;
  }
  if (fp) { fclose(fp); }

  // Transfer the raw data
  unsigned char *raw_ptr = raw;
  unsigned char *data_ptr = data;


  for (int i = 0, e = width * height; i != e; ++i) {
    // Read rgb and pad
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = 0;
  }
  free(raw);
  return true;
}


// Dump frame data in PPM format.
void dumpFrame(unsigned *frameData) {

  char fname[256];

  sprintf(fname, "out_%s_%s_%d.ppm", (imageFilename.substr(0, imageFilename.length() - 4)).c_str(), filter_type.c_str(), thresh);

  printf("Dumping %s\n", fname);

  FILE *f = fopen(fname, "wb");
  fprintf(f, "P6 %d %d %d\n", COLS, ROWS, 255);
  
  for(unsigned y = 0; y < ROWS; ++y) {
    for(unsigned x = 0; x < COLS; ++x) {
      // This assumes byte-order is little-endian.
      unsigned pixel = frameData[y * COLS + x];
      fwrite(&pixel, 1, 3, f);
    }
  }
  fprintf(f, "\n");
  fclose(f);
}


void filter(unsigned int thresh) {

  // Aplie convolution
  laplacian(input, output, COLS * ROWS, Gx);

  // Dump out frame data in PPM (ASCII).
  dumpFrame(output);
}

int main(int argc, char **argv) {

  imageFilename = "input.ppm";
  filter_type = "laplacian";
  thresh = 32;
  COLS = 1920;
  ROWS = 1080;

  if(argc == 1){}
  
  else if(argc == 4 || argc == 5){
    
    if (argv[1] != NULL) {
      imageFilename = argv[1];
    }

    if (argv[2] != NULL) {
      COLS = atoi(argv[2]);
    }

    if (argv[3] != NULL) {
      ROWS = atoi(argv[3]);
    }

    if(argc == 5 && argv[4] != NULL) {
      thresh = atoi(argv[4]);
    }
  }
  else {
    printf("Error. Uso: ./laplacian image.ppm WIDTH HEIGHT [THRESH]");
    return -1;
  }


  input = (unsigned int*)malloc(sizeof(unsigned int) * ROWS * COLS);
  output = (unsigned int*)malloc(sizeof(unsigned int) * ROWS * COLS);
  Gx = (int*)malloc(sizeof(int) * 9);


  // Read the image
  printf("Using ppm: %s\n", imageFilename.c_str());
  if (!parse_ppm(imageFilename.c_str(), COLS, ROWS, (unsigned char *)input)) {
    std::cerr << "Error: could not load " << argv[1] << std::endl;
    return -1;
  }


  printf("Running laplacian edge filter, thresh %d...\n", thresh);

  Gx[0] = -1;   Gx[1] = -1;     Gx[2] = -1;
  Gx[3] = -1;   Gx[4] =  8;     Gx[5] = -1;
  Gx[6] = -1;   Gx[7] = -1;     Gx[8] = -1;


  // Ejecutamos una vez el filtro
  filter(thresh);

  return 0;

}
