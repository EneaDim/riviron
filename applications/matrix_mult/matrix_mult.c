#include <time.h>
#include <stdlib.h>
#include "matrix.h"

#define MATRIX_SIZE 8

int main() {
    srand(time(NULL));
    
    matrix_multiply(MATRIX_SIZE);

    return 0;
}
