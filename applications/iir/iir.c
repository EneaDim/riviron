#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define FRAC_BITS 25

void exponential_smoothing_fixed(const int32_t *x, int32_t *y, size_t length,
                                 int32_t alpha_q, int frac_bits) {
    // Initialize first sample
    y[0] = x[0];

    for (size_t i = 1; i < length; i++) {
        int64_t x_term = (int64_t)alpha_q * x[i];
        int64_t y_term = (int64_t)((1 << frac_bits) - alpha_q) * y[i - 1];

        int64_t acc = x_term + y_term;

        // Normalize back to Qm.n
        y[i] = (int32_t)(acc >> frac_bits);
    }
}

int main() {
    int32_t x[5] = {134217728, 201326592, 268435456, 335544320, 402653184};  // 4.0 to 12.0 in Q6.25
    int32_t y[5];

    double alpha = 0.1;
    int32_t alpha_q = (int32_t)(alpha * (1 << FRAC_BITS));  // Convert alpha to Q format

    exponential_smoothing_fixed(x, y, 5, alpha_q, FRAC_BITS);

    for (int i = 0; i < 5; i++) {
        double xf = (double)x[i] / (1 << FRAC_BITS);
        double yf = (double)y[i] / (1 << FRAC_BITS);
        printf("x[%d] = %.3f\t y[%d] = %.3f\n", i, xf, i, yf);
    }

    return 0;
}

