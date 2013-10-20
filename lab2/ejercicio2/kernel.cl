__kernel
void matrix_mult (__global int *A, __global int *B, __global int *C) {    
  int fila = get_global_id(0);
  int columna = get_global_id(1);
  int i = 0;

  int sum;

//  for (i=0; i < N; i++) {
//    sum += A[fila*N+i] * B[i*n+columna]; 
//  }

//  C[fila*N+columna] = sum;
}