#include "helpers.h"

#define NUM_STEPS 1024

int main (void) {
  float *sum;
  cl_kernel kernel;
  cl_mem sum_buffer;
  cl_context context;
  cl_program program;
  cl_uint devices_num;
  char *program_source;
  cl_device_id device_id;
  cl_platform_id platform_id;
  cl_command_queue command_queue;

  sum = (float *) calloc (NUM_STEPS, sizeof (float));
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
  /* create a memory object, in this case this will be float number
     that will contain the values of the partial sums */
  sum_buffer = create_buffer (context, "sum_buffer", NUM_STEPS);
  /* assign this buffer as the only kernel argument */
  set_kernel_argument (kernel, sum_buffer, 0, "sum_buffer");
  /* create a command queue, here we can enqueue tasks for the device
     specified by device_id */
  command_queue = create_command_queue (context, device_id);
  /* enqueue a task to execute the kernel on the device */
  enqueue_kernel_execution (command_queue, kernel, NUM_STEPS);
  /* copy the content of the buffer from the global memory of the
     device to the host memory */
  enqueue_read_buffer_task (command_queue, sum_buffer, NUM_STEPS, sum, "sum");

  printf (ANSI_COLOR_CYAN "\nAproximación de PI: %.10lf\n\n" ANSI_COLOR_RESET, sum[0] / NUM_STEPS);

  return 0;
}
