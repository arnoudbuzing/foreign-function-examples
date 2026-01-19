#include <stdint.h>
#include <stdlib.h>

/* Macro to handle symbol exporting across different platforms */
#if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT __attribute__((visibility("default")))
#endif

/*
   Collatz function:
   - If n is even, returns n / 2
   - If n is odd, returns 3 * n + 1
*/
DLLEXPORT int64_t collatz(int64_t n) {
  if (n % 2 == 0) {
    return n / 2;
  } else {
    return 3 * n + 1;
  }
}

DLLEXPORT int64_t collatz_length(int64_t n) {
  if (n <= 0)
    return 0;
  int64_t count = 1;
  int64_t temp = n;
  while (temp != 1) {
    if (temp % 2 == 0)
      temp /= 2;
    else
      temp = 3 * temp + 1;
    count++;
  }
  return count;
}

DLLEXPORT void collatz_fill(int64_t n, int64_t *out) {
  if (n <= 0 || out == NULL)
    return;
  int64_t temp = n;
  while (1) {
    *out = temp;
    out++;
    if (temp == 1)
      break;
    if (temp % 2 == 0)
      temp /= 2;
    else
      temp = 3 * temp + 1;
  }
}

DLLEXPORT int64_t collatz_sequence(int64_t n, int64_t **out_data) {
  if (n <= 0 || out_data == NULL)
    return 0;

  size_t capacity = 16;
  int64_t *data = (int64_t *)malloc(capacity * sizeof(int64_t));
  if (data == NULL)
    return -1;

  int64_t count = 0;
  int64_t temp = n;
  while (1) {
    if ((size_t)count >= capacity) {
      capacity *= 2;
      int64_t *new_data = (int64_t *)realloc(data, capacity * sizeof(int64_t));
      if (new_data == NULL) {
        free(data);
        return -1;
      }
      data = new_data;
    }
    data[count++] = temp;
    if (temp == 1)
      break;
    if (temp % 2 == 0)
      temp /= 2;
    else
      temp = 3 * temp + 1;
  }

  *out_data = data;
  return count;
}

DLLEXPORT void collatz_free(int64_t *data) { free(data); }
