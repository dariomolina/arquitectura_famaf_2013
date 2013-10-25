#include <stdio.h>
#include <CL/cl.h>

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// Prints on screen the number of platforms availables
void platforms_number (void);

// Retorns the id of the first available platform
cl_platform_id get_platform (void);

// Retorns the number of devices availables on the platform
cl_uint devices_number (cl_platform_id platform_id);

// Returns the id of the first device available on the platfrom
cl_device_id create_device (cl_platform_id platform_id);

// Creates and returns a new context
cl_context create_context (cl_device_id device_id);

// Creates and returns a new program object
cl_program create_program (cl_context context, const char* program_source);

// Build the program in the device given
void build_program (cl_program program, cl_device_id device_id);

// Creates an OpenCL kernel object
cl_kernel create_kernel (cl_program program);

// Prints the array on scren
void print_memory_object (int *array, int length, const char *name);

// Allocates memory and intiliaze an array with random numbers
int* create_memory_object (int length, const char *name);

// Creates an OpenCL buffer object
cl_mem create_buffer (int length, cl_context context, const char* name);

// set the argument value for a specific argument of a kernel
void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char *arg_name);

// Create a command-queue on a specific device given as second parameter
cl_command_queue create_command_queue (cl_context context, cl_device_id device_id);

// Enqueue commands to write to a buffer object from host memory
void enqueue_write_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name);

// Enqueues a command to execute a kernel on a device
cl_event enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int length, cl_uint num_events_in_wait_list, const cl_event *event_wait_list);

// Enqueue commands to read from a buffer object from host memory
void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name);

// Reads the kernel source code from a .cl file
char *readKernel (void);
