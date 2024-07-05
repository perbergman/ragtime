#include <cuda_runtime.h>
#include <mma.h>
#include <stdio.h>

// Define matrix dimensions
const int M = 16;
const int N = 16;
const int K = 16;

// CUDA kernel using tensor cores
__global__ void matrixMultiplyTensorCore(half *A, half *B, float *C) {
    // Declare the fragments
    nvcuda::wmma::fragment<nvcuda::wmma::matrix_a, M, N, K, half, nvcuda::wmma::col_major> a_frag;
    nvcuda::wmma::fragment<nvcuda::wmma::matrix_b, M, N, K, half, nvcuda::wmma::row_major> b_frag;
    nvcuda::wmma::fragment<nvcuda::wmma::accumulator, M, N, K, float> c_frag;

    // Initialize the output to zero
    nvcuda::wmma::fill_fragment(c_frag, 0.0f);

    // Load the inputs
    nvcuda::wmma::load_matrix_sync(a_frag, A, K);
    nvcuda::wmma::load_matrix_sync(b_frag, B, K);

    // Perform the matrix multiplication
    nvcuda::wmma::mma_sync(c_frag, a_frag, b_frag, c_frag);

    // Store the output
    nvcuda::wmma::store_matrix_sync(C, c_frag, N, nvcuda::wmma::mem_row_major);
}

int main() {
    // Allocate and initialize matrices
    half *A, *B;
    float *C;
    cudaMalloc(&A, M * K * sizeof(half));
    cudaMalloc(&B, K * N * sizeof(half));
    cudaMalloc(&C, M * N * sizeof(float));

    // Launch the kernel
    dim3 gridDim(1, 1, 1);
    dim3 blockDim(32, 1, 1);
    matrixMultiplyTensorCore<<<gridDim, blockDim>>>(A, B, C);

    // Clean up
    cudaFree(A);
    cudaFree(B);
    cudaFree(C);

    return 0;
}
