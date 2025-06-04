#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>  // For INT32_MAX and INT32_MIN

/**
 * Fixed-point FIR filter (Qm.n format).
 *
 * Parameters:
 *   x         - Input signal array (Qm.n)
 *   x_len     - Length of the input signal
 *   coeffs    - FIR filter coefficients (Qm.n)
 *   num_taps  - Number of filter taps (length of coeffs array)
 *   y_out     - Output array (same length as x)
 *   frac_bits - Number of fractional bits (n in Qm.n)
 */
void fir_filter_fixed(const int32_t* x, int x_len,
                      const int32_t* coeffs, int num_taps,
                      int32_t* y_out, int frac_bits) {
    int half = num_taps / 2;  // Half window size for centered filter

    for (int i = 0; i < x_len; i++) {
        int64_t acc = 0;  // 64-bit accumulator to prevent overflow

        for (int j = 0; j < num_taps; j++) {
            int k = i - half + j;  // Corresponding index in input signal

            // Check bounds to avoid reading outside array
            if (k >= 0 && k < x_len) {
                // Multiply input sample by coefficient and scale back
                acc += ((int64_t)x[k] * (int64_t)coeffs[j]) >> frac_bits;
            }
        }

        // Clamp the result to fit into int32_t range
        if (acc > INT32_MAX) acc = INT32_MAX;
        if (acc < INT32_MIN) acc = INT32_MIN;

        y_out[i] = (int32_t)acc;  // Store filtered sample
    }
}

int main() {
    // Fixed-point format: Q6.25 → 6 integer bits, 25 fractional bits
    const int frac_bits = 25;

    // Example input signal: 1.0 to 5.0 converted to Q6.25
    int32_t x[] = {
        (int32_t)(1.0 * (1 << frac_bits)),
        (int32_t)(2.0 * (1 << frac_bits)),
        (int32_t)(3.0 * (1 << frac_bits)),
        (int32_t)(4.0 * (1 << frac_bits)),
        (int32_t)(5.0 * (1 << frac_bits))
    };

    // Example FIR coefficients (moving average): all equal weights
    int32_t coeffs[] = {
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits))
    };

    int x_len = sizeof(x) / sizeof(x[0]);
    int num_taps = sizeof(coeffs) / sizeof(coeffs[0]);

    int32_t y[5] = {0};  // Output buffer (same size as input)

    // Run the fixed-point FIR filter
    fir_filter_fixed(x, x_len, coeffs, num_taps, y, frac_bits);

    // Print results in floating-point format for easy visualization
    printf("Filtered output (Q6.25 → float):\n");
    for (int i = 0; i < x_len; i++) {
        float y_float = (float)y[i] / (1 << frac_bits);
        printf("y[%d] = %f\n", i, y_float);
    }

    return 0;
}

