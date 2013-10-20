/*
__kernel
void vecadd(__global int *A, __global int *B, __global int *C) {
  int tid=get_global_id(0);
  int uid=get_global_id(1);

  C[tid]=A[tid]+B[tid];
  C[uid]=0;
}
*/

__kernel
void matrix_multip(__global int *A, __global int *B, __global int *C) {
  int fila=get_global_id(0);
  int sum = 0;
  int offset_fila = 0;
  int offset_columna = 0;
  int N = 3;

  if (fila % N != 0) {
    offset_fila = fila % N;
  }

  if (fila >= N) {
    if (fila % N == 0) {
      offset_columna  = N * fila/N;
    } else {
      offset_columna = N * (fila-(fila%N))/N;
    }
  }

  for(int i=0; i < N; i++){
    sum += A[fila + i - offset_fila] * B[fila + (i*N) - offset_columna];
  }

  C[fila]=sum;
}
