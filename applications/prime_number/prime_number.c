#include <stdlib.h>
#include <time.h>

#define PRIME_LIMIT 10000

// Function to generate prime numbers
void generate_primes(int limit) {
    int *is_prime = malloc((limit + 1) * sizeof(int));
    for (int i = 0; i <= limit; i++) {
        is_prime[i] = 1; // Assume all numbers are prime
    }
    is_prime[0] = is_prime[1] = 0; // 0 and 1 are not prime

    for (int i = 2; i * i <= limit; i++) {
        if (is_prime[i]) {
            for (int j = i * i; j <= limit; j += i) {
                is_prime[j] = 0; // Mark multiples as not prime
            }
        }
    }

    // Count and print prime numbers (commented out)
    // for (int i = 2; i <= limit; i++) {
    //     if (is_prime[i]) {
    //         // Uncomment the next line to print primes
    //         // printf("%d ", i);
    //     }
    // }
    free(is_prime);
}

int main() {
    srand(time(NULL));
    // Stress test: Prime number generation
    generate_primes(PRIME_LIMIT);

    return 0;
}
