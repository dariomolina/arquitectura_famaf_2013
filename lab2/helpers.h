#include <stdio.h>
#include <CL/cl.h>

#define LENGTH 20

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

/* Returns the number of platforms on the system */
cl_uint get_platforms_number (void);

/* Returns the id of the first platform proposed by
   the system */
cl_platform_id get_platform (void);

/* Returns the number of devices compatible with
   OpenCL */
cl_uint get_devices_num (cl_platform_id platform_id);

/* Returns an array consisting of all devices ids */
cl_device_id* get_devices_ids (cl_platform_id platform_id, cl_uint num_devices);

cl_device_id create_device (cl_platform_id platform_id);

void get_platform_info (cl_platform_id platform_id, cl_platform_info info, const char * attr);

char* get_device_name (cl_device_id device_id);

cl_context create_context (cl_device_id device_id);

const char* get_program_source (void);

cl_program create_program (cl_context context, const char* program_source);

void build_program (cl_program program, cl_device_id device_id);

cl_kernel create_kernel (cl_program program);

void print_memory_object (int *array, int length, const char *name);

int* create_memory_object (int length, const char *name);

cl_mem create_buffer (int length, cl_context context, const char* name);

void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char * arg_name);

cl_command_queue create_command_queue (cl_context context, cl_device_id device_id);

void enqueue_write_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name);

void enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int length);

void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name);

void print_platform_information (cl_platform_id platform_id);

void get_device_info (cl_device_id device_id, cl_device_info info, const char * attr, int type);

cl_ulong device_information (cl_device_id device_id, int device_number);
