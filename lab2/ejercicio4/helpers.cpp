#include "helpers.h"

void platforms_number (void) {
  cl_uint err;
  cl_uint num_platforms;

  /* after the call the pointer given as third parameter will
     contain the number of platforms on the system */
  err = clGetPlatformIDs (0, NULL, &num_platforms);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "\nPlataformas disponibles" ANSI_COLOR_RESET " %u\n", num_platforms);
  } else {
    printf (ANSI_COLOR_RED "Error al obtener número de plataformas\n" ANSI_COLOR_RESET);
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
    printf (ANSI_COLOR_GREEN "Plataforma creada exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al crear plataforma\n" ANSI_COLOR_RESET);
  }

  return platform_id;
}

cl_uint devices_number (cl_platform_id platform_id) {
  cl_uint err;
  cl_uint devices_number;

  /* after the call the pointer given as fifth parameter will
     contain the number of devices on the platform specified by platform_id */
  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 0, NULL, &devices_number);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Dispositivos disponibles" ANSI_COLOR_RESET " %u\n", devices_number);
  } else {
    printf (ANSI_COLOR_RED "Error al obtener número de dispositivos\n" ANSI_COLOR_RESET);
  }

  return devices_number;
}

cl_device_id create_device (cl_platform_id platform_id) {
  cl_uint err;
  cl_device_id device_id;

  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 1, &device_id, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Dispositivo creado exitosamente\n\n" ANSI_COLOR_RESET, device_id);
  } else {
    printf (ANSI_COLOR_RED "Error al crear dispositivo\n" ANSI_COLOR_RESET);
  }

  return device_id;
}

cl_context create_context (cl_device_id device_id) {
  cl_int err;
  cl_context context;

  context = clCreateContext (NULL, 1, &device_id, NULL, NULL, &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Contexto creado exitosamente\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al crear contexto\n" ANSI_COLOR_RESET);
  }

  return context;
}

cl_program create_program (cl_context context, const char* program_source) {
  cl_int err;
  cl_program program;

  program = clCreateProgramWithSource (context, 1, (const char **) &program_source, NULL, &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "\nPrograma creado exitosamente\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al crear programa\n" ANSI_COLOR_RESET);
  }

  return program;
}

void build_program (cl_program program, cl_device_id device_id) {
  cl_int err;

  err = clBuildProgram (program, 1, &device_id, NULL, NULL, NULL);

  if (err == CL_SUCCESS){
    printf (ANSI_COLOR_GREEN "Programa compilado exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al compilar programa\n" ANSI_COLOR_RESET);
  }
}

cl_kernel create_kernel (cl_program program) {
  cl_int err;
  cl_kernel kernel;

  kernel = clCreateKernel (program, "reduce", &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Kernel creado exitosamente\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al crear kernel\n" ANSI_COLOR_RESET);
  }

  return kernel;
}

cl_mem create_buffer (cl_context context, const char* name, int size) {
  cl_int err;
  cl_mem sum_buffer;

  sum_buffer = clCreateBuffer (context, CL_MEM_READ_WRITE, size * sizeof (float), NULL, &err);

  if (err == CL_SUCCESS){
    printf (ANSI_COLOR_YELLOW "\nBuffer" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW "creado exitosamente\n\n" ANSI_COLOR_RESET, name);
  } else {
    printf (ANSI_COLOR_RED "Error al crear buffer\n" ANSI_COLOR_RESET);
  }

  return sum_buffer;
}

void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char * arg_name) {
  cl_int err;

  err = clSetKernelArg (kernel, arg_num, sizeof (cl_mem), &arg);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Argumento de kernel" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW "configurado exitosamente\n\n" ANSI_COLOR_RESET, arg_name);
  } else {
    printf (ANSI_COLOR_RED "Error al configurar argumento de kernel\n" ANSI_COLOR_RESET);
  }
}

cl_command_queue create_command_queue (cl_context context, cl_device_id device_id) {
  cl_int err;
  cl_command_queue command_queue;

  command_queue = clCreateCommandQueue (context, device_id, 0, &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Cola de comandos creada exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al crear cola de comandos\n" ANSI_COLOR_RESET);
  }

  return command_queue;
}

void enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int num_steps) {
  cl_int err;
  size_t local = num_steps;
  size_t global = num_steps;

  err = clEnqueueNDRangeKernel (command_queue, kernel, 1, NULL, &global, &local, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Kernel enviado al dispositivo exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error al enviar kernel al dispositivo\n" ANSI_COLOR_RESET);
  }
}

void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int num_steps, float *sum, const char* name) {
  cl_int err;
  err = clEnqueueReadBuffer (command_queue, buffer, CL_TRUE, 0, num_steps * sizeof (float), sum, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Buffer" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW "copiado exitosamente desde el dispositivo\n" ANSI_COLOR_RESET, name);
  } else {
    printf (ANSI_COLOR_RED "Error al copiar buffer desde el dispositivo\n" ANSI_COLOR_RESET);
  }
}

char * readKernel(void) {
  size_t *source_length;
  FILE *fp = fopen ("kernel.cl", "r");

  if (fp == NULL) {
    printf (ANSI_COLOR_RED "Cannot Open Kernel.cl\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_GREEN "Kernel.cl Opened\n" ANSI_COLOR_RESET);
  }

  fseek (fp, 0, SEEK_END);
  source_length[0] = ftell (fp);

  if (source_length[0] == 0) {
    printf ("Kernel.cl is empty\n");
  } else {
    printf ("Kernel.cl length: %zu bytes\n", source_length[0]);
  }

  char *source = (char*) calloc (source_length[0] + 1, 1);
  if (source == 0) {
    printf (ANSI_COLOR_RED "Memory allocation failed" ANSI_COLOR_RESET);
  }

  fseek (fp, 0, SEEK_SET);
  fread (source, 1, source_length[0], fp);
  printf (ANSI_COLOR_GREEN "Kernel.cl Read\n" ANSI_COLOR_RESET);

  return source;
}
