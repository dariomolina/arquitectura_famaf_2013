#include "helpers.h"

int main (void) {
  cl_platform_id platform_id;
  cl_uint devices_num;
  cl_device_id device_id;
  cl_context context;
  char * program_source;
  cl_program program;
  cl_kernel kernel;

  int * a_mem;
  int * b_mem;
  int * c_mem;

  const char * a;
  const char * b;
  const char * c;

  cl_mem a_in, b_in, dim_in, c_out;
  cl_command_queue command_queue;

  a = (char *) calloc(10, sizeof(char));
  a = "Matriz A";

  b = (char *) calloc(10, sizeof(char));
  b = "Matriz B";

  c = (char *) calloc(10, sizeof(char));
  c = "Matriz C";

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
  a_mem = create_memory_object (N*N, a);
  b_mem = create_memory_object (N*N, b);
  c_mem = create_memory_object (N*N, c);
  a_in = create_buffer(N*N, context, a);
  b_in = create_buffer(N*N, context, b);
  c_out = create_buffer(N*N, context, c);
  separator ();
  set_kernel_argument (kernel, a_in, 0, a);
  set_kernel_argument (kernel, b_in, 1, b);
  set_kernel_argument (kernel, c_out, 2, c);
  separator ();
  command_queue = create_command_queue (context, device_id);
  enqueue_write_buffer_task (command_queue, a_in, N*N, a_mem, a);
  enqueue_write_buffer_task (command_queue, b_in, N*N, b_mem, b);
  separator ();
  enqueue_kernel_execution (command_queue, kernel, N*N);
  enqueue_read_buffer_task (command_queue, c_out, N*N,  c_mem, c);

  print_memory_object (c_mem, N*N, c);

  return 0;
}
