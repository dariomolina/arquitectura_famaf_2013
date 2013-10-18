#include "helpers.h"

int main () {
  int *a, *b, *c;
  cl_kernel kernel;
  cl_context context;
  cl_program program;
  cl_device_id device_id;
  cl_uint num_devices = 0;
  char *device_name = NULL;
  cl_uint num_platforms = 0;
  const char* program_source;
  cl_platform_id platform_id;
  cl_mem a_mem, b_mem, c_mem;
  cl_command_queue command_queue;

  num_platforms = get_platforms_number ();
  platform_id = create_platform (num_platforms);
  num_devices = get_devices_num (platform_id);
  device_id = create_device (platform_id);
  print_platform_information (platform_id);
  device_name = get_device_name (device_id);
  context = create_context (device_id);
  program_source = get_program_source ();
  program = create_program (context, program_source);
  build_program (program, device_id);
  kernel = create_kernel (program);
  a = create_memory_object (10, "a");
  b = create_memory_object (10, "b");
  c = create_memory_object (10, "c");
  a_mem = create_buffer (10, context, "a_mem");
  b_mem = create_buffer (10, context, "b_mem");
  c_mem = create_buffer (10, context, "c_mem");
  set_kernel_argument (kernel, a_mem, 0, "a_mem");
  set_kernel_argument (kernel, b_mem, 1, "b_mem");
  set_kernel_argument (kernel, c_mem, 2, "c_mem");
  command_queue = create_command_queue (context, device_id);
  enqueue_write_buffer_task (command_queue, a_mem, 10, a, "a_mem");
  enqueue_write_buffer_task (command_queue, b_mem, 10, b, "b_mem");
  enqueue_kernel_execution (command_queue, kernel, 10);
  clFinish (command_queue);
  enqueue_read_buffer_task (command_queue, c_mem, 10, c, "c_mem");
  print_memory_object (c, 10, "c");

  return 0;
}
