#include <stdio.h>
#include <CL/cl.h>

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

void platforms_number (void);
cl_platform_id get_platform (void);
cl_uint devices_number (cl_platform_id platform_id);
cl_device_id create_device (cl_platform_id platform_id);
cl_context create_context (cl_device_id device_id);
cl_program create_program (cl_context context, const char* program_source);
void build_program (cl_program program, cl_device_id device_id);
cl_kernel create_kernel (cl_program program);
cl_mem create_buffer (cl_context context, const char* name, int size);
void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char *arg_name);
cl_command_queue create_command_queue (cl_context context, cl_device_id device_id);
void enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int num_steps);
void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int num_steps, float *sum, const char* name);
char *readKernel (void);
