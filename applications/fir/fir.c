#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

void fir_filter_fixed(const int32_t* x, int x_len,
                      const int32_t* coeffs, int num_taps,
                      int32_t* y_out, int frac_bits) {
    int half = num_taps / 2;

    for (int i = 0; i < x_len; i++) {
        int64_t acc = 0;
        for (int j = 0; j < num_taps; j++) {
            int k = i - half + j;
            if (k >= 0 && k < x_len) {
                // Accumulo dei prodotti scalati
                acc += ((int64_t)x[k] * (int64_t)coeffs[j]) >> frac_bits;
            }
        }

        // Clipping del risultato per rientrare in int32_t
        if (acc > INT32_MAX) acc = INT32_MAX;
        if (acc < INT32_MIN) acc = INT32_MIN;

        y_out[i] = (int32_t)acc;
    }
}
int main() {
    // Esempio con segnale e coeff in Q6.25 (frac_bits = 25)
    const int frac_bits = 25;

    int32_t x[] = {
        (int32_t)(1.0 * (1 << frac_bits)),
        (int32_t)(2.0 * (1 << frac_bits)),
        (int32_t)(3.0 * (1 << frac_bits)),
        (int32_t)(4.0 * (1 << frac_bits)),
        (int32_t)(5.0 * (1 << frac_bits))
    };

    int32_t coeffs[] = {
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits)),
        (int32_t)(0.2 * (1 << frac_bits))
    };

    int x_len = sizeof(x) / sizeof(x[0]);
    int num_taps = sizeof(coeffs) / sizeof(coeffs[0]);
    int32_t y[5] = {0};

    fir_filter_fixed(x, x_len, coeffs, num_taps, y, frac_bits);

    printf("Output (Q6.25 -> float):\n");
    for (int i = 0; i < x_len; i++) {
        float y_float = (float)y[i] / (1 << frac_bits);
        printf("y[%d] = %f\n", i, y_float);
    }

    return 0;
}

