#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// Number of fractional bits for Qm.n fixed-point format
#define FRAC_BITS 25

/**
 * Exponential smoothing filter (fixed-point version).
 *
 * This function applies a simple IIR low-pass filter:
 *     y[n] = α * x[n] + (1 - α) * y[n-1]
 *
 * Inputs:
 *   x         - Input array of samples in Qm.n fixed-point format
 *   y         - Output array (must be same length as x)
 *   length    - Number of samples
 *   alpha_q   - α in fixed-point (Qm.n) format
 *   frac_bits - Number of fractional bits (n in Qm.n)
 */
void exponential_smoothing_fixed(const int32_t *x, int32_t *y, size_t length,
                                 int32_t alpha_q, int frac_bits) {
    // Initialize the first output sample (same as input)
    y[0] = x[0];

    for (size_t i = 1; i < length; i++) {
        // Multiply input sample by alpha (fixed-point)
        int64_t x_term = (int64_t)alpha_q * x[i];

        // Multiply previous output by (1 - alpha) in fixed-point
        int64_t y_term = (int64_t)((1 << frac_bits) - alpha_q) * y[i - 1];

        // Accumulate and normalize back to Qm.n format
        int64_t acc = x_term + y_term;
        y[i] = (int32_t)(acc >> frac_bits);  // Shift right to rescale
    }
}

int main() {
    // Input samples in Q6.25 fixed-point format (representing values from 4.0 to 12.0)
    int32_t x[5] = {
        134217728,  // 4.0 * 2^25
        201326592,  // 6.0 * 2^25
        268435456,  // 8.0 * 2^25
        335544320,  // 10.0 * 2^25
        402653184   // 12.0 * 2^25
    };

    int32_t y[5];  // Output array

    // Set alpha smoothing factor (e.g., 0.1), and convert it to fixed-point
    double alpha = 0.1;
    int32_t alpha_q = (int32_t)(alpha * (1 << FRAC_BITS));  // Q0.25

    // Apply the smoothing filter
    exponential_smoothing_fixed(x, y, 5, alpha_q, FRAC_BITS);

    // Print both input and filtered output in float format for readability
    for (int i = 0; i < 5; i++) {
        double xf = (double)x[i] / (1 << FRAC_BITS);
        double yf = (double)y[i] / (1 << FRAC_BITS);
        printf("x[%d] = %.3f\t y[%d] = %.3f\n", i, xf, i, yf);
    }

    return 0;
}

