#include <stdio.h>
#include <CL/cl.h>

#define LENGTH 20

cl_uint get_platforms_number (void);

cl_platform_id create_platform (cl_uint num_platforms);

cl_uint get_devices_num (cl_platform_id platform_id);

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
