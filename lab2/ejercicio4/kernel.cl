__kernel
void reduce (__global float* result) {
  float x;
  int offset, global_index;

  global_index = get_global_id (0);
  x = (global_index + 0.5) * (1.0 / 1024);
  result[global_index] = 4.0 / (1.0 + x * x);

  barrier (CLK_LOCAL_MEM_FENCE);

  for (offset = get_global_size (0) / 2; offset > 0; offset = offset / 2) {
    if (global_index < offset)
      result[global_index] = result[global_index] + result[global_index + offset];
    barrier (CLK_LOCAL_MEM_FENCE);
  }
}