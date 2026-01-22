#include <stdio.h>
#include <stdlib.h>

#if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT __attribute__((visibility("default")))
#endif

// Computes y = A * x
// A is a flattened 2D array of size rows * cols (row-major)
// x is a vector of length cols
// y is a vector of length rows (pre-allocated)
DLLEXPORT void matrix_vector_multiply(double *A, double *x, double *y, int rows,
                                      int cols) {
  for (int i = 0; i < rows; i++) {
    double sum = 0.0;
    for (int j = 0; j < cols; j++) {
      // Row-major index: i * cols + j
      sum += A[i * cols + j] * x[j];
    }
    y[i] = sum;
  }
}

// Transposes a SQUARE matrix in-place.
// A is a flattened 2D array of size n * n
DLLEXPORT int transpose_square_matrix(double *A, int n) {
  if (A == NULL)
    return -1;
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      double temp = A[i * n + j];
      A[i * n + j] = A[j * n + i];
      A[j * n + i] = temp;
    }
  }
  return n;
}

// Helper to fill a matrix with some values for testing C-side generation
DLLEXPORT void fill_matrix(double *A, int rows, int cols) {
  for (int i = 0; i < rows * cols; i++) {
    A[i] = (double)i;
  }
}
