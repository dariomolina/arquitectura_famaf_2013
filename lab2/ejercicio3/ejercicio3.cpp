#include "helpers.h"

#define LENGTH 10

int main (void) {
  int *a;
  cl_mem a_in;
  cl_event event;
  cl_kernel kernel;
  cl_context context;
  cl_program program;
  cl_uint devices_num;
  char *program_source;
  cl_device_id device_id;
  cl_platform_id platform_id;
  cl_command_queue command_queue;

  program_source = (char *) calloc (1000, sizeof (char));
  program_source = readKernel ();

  /* number of platforms on the system */
  platforms_number ();
  /* id of the first platform proposed by the system */
  platform_id = get_platform ();
  /* number of devices on the platform specified by platform_id */
  devices_num = devices_number (platform_id);
  /* id of the first device proposed by the system on the platform
     specified by platform_id */
  device_id = create_device (platform_id);
  /* create a context to stablish a communication channel between the
     host process and the device */
  context = create_context (device_id);
  /* create a program providing the source code */
  program = create_program (context, program_source);
  /* compile the program for the specific device architecture */
  build_program (program, device_id);
  /* create a kernel given the program */
  kernel = create_kernel (program);
  /* create a memory object, in this case this will be an array of
     integers of length specified by the LENGTH macro */
  a = create_memory_object (LENGTH, "a");
  /* create a buffer, this will be allocated on the global memory of
     the device */
  a_in = create_buffer (LENGTH, context, "a_in");
  /* assign this buffer as the only kernel argument */
  set_kernel_argument (kernel, a_in, 0, "a_in");
  /* create a command queue, here we can enqueue tasks for the device
     specified by device_id */
  command_queue = create_command_queue (context, device_id);
  /* copy the memory object allocated on the host memory into the
     buffer created on the global memory of the device */
  enqueue_write_buffer_task (command_queue, a_in, LENGTH, a, "a_in");
  /* enqueue a task to execute the kernel on the device */
  event = enqueue_kernel_execution (command_queue, kernel, LENGTH, 0, NULL);
  enqueue_kernel_execution (command_queue, kernel, LENGTH, 1, &event);
  /* copy the content of the buffer from the global memory of the
     device to the host memory */
  enqueue_read_buffer_task (command_queue, a_in, LENGTH,  a, "a_in");
  /* print the memory object with the result of the execution */
  print_memory_object (a, LENGTH, "a");

  return 0;
}
