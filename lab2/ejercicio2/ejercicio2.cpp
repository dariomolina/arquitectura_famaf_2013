#include "helpers.h"

int main (void) {
  int dim_mem = N;
  cl_kernel kernel;
  cl_context context;
  cl_program program;
  cl_uint devices_num;
  char * program_source;
  cl_device_id device_id;
  int * a_mem, * b_mem, * c_mem;
  cl_platform_id platform_id;
  cl_command_queue command_queue;
  cl_mem a_in, b_in, dim_in, c_out;

  program_source = (char *) calloc(1000, sizeof(char));

  platforms_number ();
  platform_id = get_platform ();
  devices_num = devices_number (platform_id);
  device_id = create_device(platform_id);
  context = create_context(device_id);
  program_source = readKernel ();
  program = create_program (context, program_source);
  build_program (program, device_id);
  kernel = create_kernel (program);
  a_mem = create_memory_object (N*N, "Matriz A");
  a_in = create_buffer (N*N, context, "Matriz A");
  b_mem = create_memory_object (N*N, "Matriz B");
  b_in = create_buffer (N*N, context, "Matriz B");
  c_mem = create_memory_object (N*N, "Matriz C");
  c_out = create_buffer (N*N, context, "Matriz C");
  dim_in = create_buffer (1, context, "Dimension");
  separator ();
  set_kernel_argument (kernel, a_in, 0, "Matriz A");
  set_kernel_argument (kernel, b_in, 1, "Matriz B");
  set_kernel_argument (kernel, c_out, 2, "Matriz C");
  set_kernel_argument (kernel, dim_in, 3, "Dimension");
  separator ();
  command_queue = create_command_queue (context, device_id);
  enqueue_write_buffer_task (command_queue, a_in, N*N, a_mem, "Matriz A");
  enqueue_write_buffer_task (command_queue, b_in, N*N, b_mem, "Matriz B");
  enqueue_write_buffer_task (command_queue, dim_in, 1, &dim_mem, "Dimension");
  separator ();
  enqueue_kernel_execution (command_queue, kernel, N);
  enqueue_read_buffer_task (command_queue, c_out, N*N, c_mem, "Matriz C");

  printf("\nMatriz Calculada de forma paralela\n\n");
  print_memory_object (c_mem, N*N, "Matriz C");

  printf("\nMatriz Calculada de forma serial\n\n");
  matrix_multip (a_mem, b_mem, "Matriz C");

  return 0;
}
