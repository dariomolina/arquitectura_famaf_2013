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

/* number of platforms on the system */
void platforms_number (void);

/* id of the first platform proposed by the system */
cl_platform_id get_platform (void);

/* information about the platform specified by platform_id */
void platform_information (cl_platform_id platform_id);

/* number of devices on the platform specified by platform_id */
cl_uint devices_number (cl_platform_id platform_id);

/* array of devices ids on the platform specified by platform_id,
   number of devices on the platform should be specified */
cl_device_id* devices_ids (cl_platform_id platform_id, cl_uint devices_number);

/* information about all devices on the platform specified by
   platform_id, number of devices on the platform should be specified */
void devices_information (cl_device_id *devices_ids, cl_uint devices_number);
