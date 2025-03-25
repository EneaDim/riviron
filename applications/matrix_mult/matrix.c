#include "matrix.h"
#include <time.h>
#include <stdlib.h>

void matrix_multiply(int size) {
    int **a = malloc(size * sizeof(int *));
    int **b = malloc(size * sizeof(int *));
    int **c = malloc(size * sizeof(int *));
    
    for (int i = 0; i < size; i++) {
        a[i] = malloc(size * sizeof(int));
        b[i] = malloc(size * sizeof(int));
        c[i] = malloc(size * sizeof(int));
    }

    // Initialize matrices
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            a[i][j] = rand() % 100;
            b[i][j] = rand() % 100;
            c[i][j] = 0;
        }
    }

    // Matrix multiplication
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            for (int k = 0; k < size; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }

    // Free allocated memory
    for (int i = 0; i < size; i++) {
        free(a[i]);
        free(b[i]);
        free(c[i]);
    }
    free(a);
    free(b);
    free(c);
}
