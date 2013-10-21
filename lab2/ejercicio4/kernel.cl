__kernel
void function (__global float *sum) {
  float x = 0.0, delta = 1.0 / 1000;
  int global_id = get_global_id (0);

  x = (global_id + 0.5) * delta;
  sum[global_id] = 4.0 / (1.0 + x * x);
}
