#include "helpers.h"

static void platform_info (cl_platform_id platform_id, cl_platform_info info, const char * attr) {
  cl_uint err;
  char *platform_info;

  platform_info = (char *) calloc (1000, sizeof (char));
  /* after the call, the pointer given as fourth parameter will
     contain the information required specified by the flag info */
  err = clGetPlatformInfo (platform_id, info, 1000 * sizeof (char), platform_info, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "%s" ANSI_COLOR_RESET " %s\n", attr, platform_info);
  } else {
    printf ("Error al obtener %s de la plataforma\n", attr);
  }
}

static cl_ulong device_information (cl_device_id device_id, int device_number) {
  size_t p_size;
  char name[500];
  cl_uint entries, number_of_cores;
  cl_ulong long_entries, clk_frequency = 0;

  clGetDeviceInfo (device_id, CL_DEVICE_NAME, 500, name, NULL);
  printf (ANSI_COLOR_CYAN "Device #%d \t Name %s\n\n" ANSI_COLOR_RESET, device_number, name);
  clGetDeviceInfo (device_id, CL_DRIVER_VERSION, 500, name, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Driver version" ANSI_COLOR_RESET "                      %s\n", name);
  clGetDeviceInfo (device_id, CL_DEVICE_GLOBAL_MEM_SIZE, sizeof (cl_ulong), &long_entries, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Global Memory" ANSI_COLOR_RESET "                       %llu MB\n", long_entries / 1024 / 1024);
  clGetDeviceInfo (device_id, CL_DEVICE_GLOBAL_MEM_CACHE_SIZE, sizeof (cl_ulong), &long_entries, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Global Memory Cache" ANSI_COLOR_RESET "                 %llu KB\n", long_entries / 1024);
  clGetDeviceInfo (device_id, CL_DEVICE_LOCAL_MEM_SIZE, sizeof (cl_ulong), &long_entries, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Local Memory" ANSI_COLOR_RESET "                        %llu KB\n", long_entries / 1024);
  clGetDeviceInfo (device_id, CL_DEVICE_MAX_CLOCK_FREQUENCY, sizeof (cl_ulong), &clk_frequency, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Max clock" ANSI_COLOR_RESET "                           %llu MHz\n", clk_frequency);
  clGetDeviceInfo (device_id, CL_DEVICE_MAX_WORK_GROUP_SIZE, sizeof (size_t), &p_size, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Max Work Group Size" ANSI_COLOR_RESET "                 %d\n", p_size);
  clGetDeviceInfo (device_id, CL_DEVICE_MAX_COMPUTE_UNITS, sizeof (cl_uint), &number_of_cores, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Number of parallel compute cores" ANSI_COLOR_RESET "    %d\n", number_of_cores);
  clGetDeviceInfo (device_id,  CL_DEVICE_VENDOR , 500, name, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Device Vendor" ANSI_COLOR_RESET "                       %s\n", name);
  clGetDeviceInfo (device_id, CL_DEVICE_VERSION, 500, name, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Device version" ANSI_COLOR_RESET "                      %s\n", name);
  clGetDeviceInfo (device_id, CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, sizeof (cl_uint), &entries, NULL);
  printf (ANSI_COLOR_YELLOW "\t\t Max Work Item Dimensions" ANSI_COLOR_RESET "            %d\n", entries);
  printf (ANSI_COLOR_YELLOW "\t\t Performance" ANSI_COLOR_RESET "                         %llu\n\n", clk_frequency * number_of_cores);

  return clk_frequency * number_of_cores;
}

void platforms_number (void) {
  cl_uint err;
  cl_uint num_platforms;

  /* after the call the pointer given as third parameter will
     contain the number of platforms on the system */
  err = clGetPlatformIDs (0, NULL, &num_platforms);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Plataformas disponibles" ANSI_COLOR_RESET " %u\n", num_platforms);
  } else {
    printf ("Error al obtener número de plataformas\n");
  }
}

cl_platform_id get_platform (void) {
  cl_uint err;
  cl_platform_id platform_id;

  /* after the call the pointer given as second parameter will
     be the list of all ids of platforms on the system, the number
     will be restricted by the number given as first parameter, in
     this case platform_id will contain the id of the first platform
     proposed by the system */
  err = clGetPlatformIDs (1, &platform_id, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_CYAN "Plataforma creada exitosamente\n\n" ANSI_COLOR_RESET );
  } else {
    printf ("Error al crear plataforma\n");
  }

  return platform_id;
}

void platform_information (cl_platform_id platform_id) {
  /* print information of the platform specified by platform_id, this
     include name, profile, version, vendor & extensions */
  platform_info (platform_id, CL_PLATFORM_NAME, "Nombre");
  platform_info (platform_id, CL_PLATFORM_PROFILE, "Perfil");
  platform_info (platform_id, CL_PLATFORM_VERSION, "Versión");
  platform_info (platform_id, CL_PLATFORM_VENDOR, "Fabricante");
  platform_info (platform_id, CL_PLATFORM_EXTENSIONS, "Extensiones");
}

cl_uint devices_number (cl_platform_id platform_id) {
  cl_uint err;
  cl_uint devices_number;

  /* after the call the pointer given as fifth parameter will
     contain the number of devices on the platform specified by platform_id */
  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 0, NULL, &devices_number);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "\nDispositivos disponibles" ANSI_COLOR_RESET " %u \n", devices_number);
  } else {
    printf ("Error al obtener número de dispositivos\n");
  }

  return devices_number;
}

cl_device_id* devices_ids (cl_platform_id platform_id, cl_uint devices_number) {
  cl_uint err;
  cl_device_id *device_ids = NULL;

  device_ids = (cl_device_id *) calloc (devices_number, sizeof (cl_device_id));
  /* after the call the pointer given as fourth parameter will
     contain the devices ids on the platform specified by platform_id */
  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, devices_number, device_ids, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_CYAN "Dispositivos obtenidos exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf ("Error al obtener dispositivos\n");
  }

  return device_ids;
}

void devices_information (cl_device_id *devices_ids, cl_uint devices_number) {
  char* name = NULL;
  int i = 0, maxp_device_index = 0;
  cl_ulong max_performance = 0, performance = 0;

  for (i = 0; i < devices_number; i++) {
    performance = device_information (devices_ids[i], i);

    if (max_performance < performance) {
      max_performance = performance;
      maxp_device_index = i;
    }
  }

  name = (char *) calloc (500, sizeof (char));
  clGetDeviceInfo (devices_ids[maxp_device_index], CL_DEVICE_NAME, 500, name, NULL);
  printf (ANSI_COLOR_CYAN "Dispositivo con mejor performance: %s\n\n" ANSI_COLOR_RESET, name);
}
