__kernel
void matrix_multip (__global int *A, __global int *B , __global int *C, __global int *N) {
  int dim = N[0];
  int fila = get_global_id(0);
  int columna = get_global_id(1);

  int sum = 0;

  for (int i=0; i < dim; i++) {
    sum += A[fila*dim+i] * B[i*dim+columna];
  }

  C[fila*dim+columna] = sum;
}