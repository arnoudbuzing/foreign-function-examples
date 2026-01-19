#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT __attribute__((visibility("default")))
#endif

// A simple structure to demonstrate struct passing
typedef struct {
  double x;
  double y;
} Point;

DLLEXPORT int add_integers(int a, int b) { return a + b; }

DLLEXPORT double multiply_doubles(double a, double b) { return a * b; }

DLLEXPORT int get_string_length(const char *s) {
  if (s == NULL)
    return 0;
  return (int)strlen(s);
}

DLLEXPORT char *reverse_string(const char *s) {
  if (s == NULL)
    return NULL;
  size_t len = strlen(s);
  char *rev = (char *)malloc(len + 1);
  if (rev == NULL)
    return NULL;
  for (size_t i = 0; i < len; i++) {
    rev[i] = s[len - 1 - i];
  }
  rev[len] = '\0';
  return rev;
}

DLLEXPORT void free_string(char *s) { free(s); }

DLLEXPORT double point_distance(Point p1, Point p2) {
  double dx = p1.x - p2.x;
  double dy = p1.y - p2.y;
  return sqrt(dx * dx + dy * dy);
}

DLLEXPORT void print_hello() {
  printf("Hello from C code!\n");
  fflush(stdout); // Ensure output is printed immediately
}
