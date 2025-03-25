#include <stdlib.h>
#include <time.h>

#define FIB_LIMIT 40

// Function to calculate Fibonacci numbers
unsigned long long fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
    srand(time(NULL));
    // Stress test: Fibonacci calculation
    unsigned long long fib_result = fibonacci(FIB_LIMIT);
    return 0;
}

