#include "helpers.h"

void platforms_number (void) {
  cl_uint err;
  cl_uint num_platforms;

  /* after the call the pointer given as third parameter will
     contain the number of platforms on the system */
  err = clGetPlatformIDs (0, NULL, &num_platforms);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Plataformas disponibles" ANSI_COLOR_RESET " %u\n", num_platforms);
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
    printf (ANSI_COLOR_YELLOW "Dispositivos disponibles" ANSI_COLOR_RESET " %u \n", devices_number);
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
    printf (ANSI_COLOR_YELLOW "Dispositivo Creado Exitosamente: Id ->" ANSI_COLOR_RESET " %u\n\n", device_id);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Dispositivo!\n\n" ANSI_COLOR_RESET);
  }

  return device_id;
}

cl_context create_context (cl_device_id device_id) {
  cl_int err;
  cl_context context;

  context = clCreateContext (NULL, 1, &device_id, NULL, NULL, &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Contexto Creado Exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Contexto\n\n" ANSI_COLOR_RESET);
  }

  return context;
}

cl_program create_program (cl_context context, const char* program_source) {
  cl_int err;
  cl_program program;

  program = clCreateProgramWithSource (context, 1, (const char **) &program_source, NULL, &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Programa Creado Exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Programa\n\n" ANSI_COLOR_RESET);
  }

  return program;
}

void build_program (cl_program program, cl_device_id device_id) {
  cl_int err;

  err = clBuildProgram (program, 1, &device_id, NULL, NULL, NULL);

  if (err == CL_SUCCESS){
    printf (ANSI_COLOR_GREEN "Programa Compilado Exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Compilar Programa\n\n" ANSI_COLOR_RESET);
  }
}

cl_kernel create_kernel (cl_program program) {
  cl_int err;
  cl_kernel kernel;

  kernel = clCreateKernel (program, "matrix_multip", &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Kernel Creado Exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Kernel\n\n" ANSI_COLOR_RESET);
  }

  return kernel;
}

void print_memory_object (int *array, int length, const char *name) {
  int i;

  printf ("%s = | ", name);
  for (i = 0; i < length - 1; i++) {
    if (i != 0 && i % N == 0) {
      printf("| \n           | ");
    }
    printf ("%d ", array[i]);
  }
  printf ("%d |\n\n", array[length - 1]);
}

int* create_memory_object (int length, const char *name) {
  int i;
  int *array;

  array = (int *) calloc (length, sizeof (int));

  if (array != NULL) {
    printf (ANSI_COLOR_GREEN "Arreglo De Datos Creado Exitosamente\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Arreglo De Datos\n" ANSI_COLOR_RESET);
  }

  for (i = 0; i < length; i++) {
    array[i] = (int) ((10.0 * rand()) / RAND_MAX);
  }

  print_memory_object (array, length, name);

  return array;
}

cl_mem create_buffer (int length, cl_context context, const char* name) {
  cl_int err;
  cl_mem array;

  array = clCreateBuffer (context, CL_MEM_READ_ONLY, sizeof (int) * length, NULL, &err);

  if (err == CL_SUCCESS){
    printf (ANSI_COLOR_YELLOW "Buffer" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW "Creado Exitosamente\n" ANSI_COLOR_RESET, name);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Buffer\n" ANSI_COLOR_RESET);
  }

  return array;
}

void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char * arg_name) {
  cl_int err;

  err = clSetKernelArg (kernel, arg_num, sizeof (cl_mem), &arg);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Argumento De Kernel" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW "Configurado Exitosamente\n" ANSI_COLOR_RESET, arg_name);
  } else {
    printf (ANSI_COLOR_RED "Error Al Configurar Argumento De Kernel\n" ANSI_COLOR_RESET);
  }
}

cl_command_queue create_command_queue (cl_context context, cl_device_id device_id) {
  cl_int err;
  cl_command_queue command_queue;

  command_queue = clCreateCommandQueue (context, device_id, 0, &err);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Cola De Comandos Creada Exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Crear Cola De Comandos\n\n" ANSI_COLOR_RESET);
  }

  return command_queue;
}

void enqueue_write_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name) {
  cl_int err;

  err = clEnqueueWriteBuffer (command_queue, buffer, CL_TRUE, 0, sizeof (int) * length, array, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Buffer" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW "Copiado Exitosamente Al Dispositivo\n" ANSI_COLOR_RESET, name);
  } else {
    printf (ANSI_COLOR_RED "Error Al Copiar Buffer Al Dispositivo\n" ANSI_COLOR_RESET);
  }
}

void enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int length) {
  cl_int err;
  size_t local = length;
  size_t global = length;

  err = clEnqueueNDRangeKernel (command_queue, kernel, 1, NULL, &global, &local, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_GREEN "Kernel Enviado Al Dispositivo Exitosamente\n\n" ANSI_COLOR_RESET);
  } else {
    printf (ANSI_COLOR_RED "Error Al Enviar Kernel Al Dispositivo\n\n" ANSI_COLOR_RESET);
  }
}

void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name) {
  cl_int err;
  err = clEnqueueReadBuffer (command_queue, buffer, CL_TRUE, 0, sizeof (int) * length, array, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf (ANSI_COLOR_YELLOW "Buffer" ANSI_COLOR_RESET " %s " ANSI_COLOR_YELLOW " Copiado Exitosamente Desde El Dispositivo\n" ANSI_COLOR_RESET, name);
  } else {
    printf (ANSI_COLOR_RED "Error Al Copiar Buffer Desde El Dispositivo\n" ANSI_COLOR_RESET);
  }
}

char * readKernel(void) {
  size_t *source_length;
  FILE *fp = fopen("kernel.cl", "r");

  if (fp == NULL) {
    printf(ANSI_COLOR_RED "Cannot Open Kernel.cl\n" ANSI_COLOR_RESET);
  } else {
    printf(ANSI_COLOR_GREEN "Kernel.cl Opened\n" ANSI_COLOR_RESET);
  }

  fseek(fp, 0, SEEK_END);
  source_length[0] = ftell(fp);

  if (source_length[0] == 0) {
    printf(ANSI_COLOR_RED "Kernel.cl is empty\n" ANSI_COLOR_RESET);
  } else {
    printf(ANSI_COLOR_YELLOW "Kernel.cl length:" ANSI_COLOR_RESET  " %zu" ANSI_COLOR_YELLOW " bytes\n" ANSI_COLOR_RESET, source_length[0]);
  }

  char *source = (char*) calloc(source_length[0] + 1, 1);
  if (source == 0) {
    printf(ANSI_COLOR_RED "Memory allocation failed" ANSI_COLOR_RESET);
  }

  fseek(fp, 0, SEEK_SET);
  fread(source, 1, source_length[0], fp);
  printf(ANSI_COLOR_GREEN "Kernel.cl Read\n" ANSI_COLOR_RESET);

  return source;
}

void separator (void) {
  printf("\n");
}
