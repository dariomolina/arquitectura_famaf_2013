__kernel
void function (__global int *A) {
  int array[2];
  int global_id = get_global_id (0);

  if (global_id % 2 == 0) {
    array[0] = A[global_id];
    array[1] = A[global_id + 1];
  } else {
    array[0] = A[global_id - 1];
    array[1] = A[global_id];
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  A[global_id] = array[0] + array[1];
}
