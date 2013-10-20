#include "helpers.h"

cl_uint get_platforms_number (void) {
  cl_uint err;
  cl_uint num_platforms;

  err = clGetPlatformIDs (0, NULL, &num_platforms);

  if (err == CL_SUCCESS) {
    printf ("Plataformas Disponibles: %u\n\n", num_platforms);
  } else {
    printf ("Error Al Obtener Número De Plataformas!\n\n");
  }

  return num_platforms;
}

cl_platform_id get_platform (void) {
  cl_uint err;
  cl_platform_id platform_id;

  err = clGetPlatformIDs (1, &platform_id, NULL);

  if (err == CL_SUCCESS) {
    printf ("Plataforma Creada Exitosamente: id -> %u\n\n", platform_id);
  } else {
    printf ("Error Al Crear Plataforma\n\n");
  }

  return platform_id;
}

cl_uint get_devices_num (cl_platform_id platform_id) {
  cl_uint err;
  cl_uint num_devices;

  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 0, NULL, &num_devices);

  if (err == CL_SUCCESS) {
    printf ("Dispositivos Disponibles: %u \n\n", num_devices);
  } else {
    printf ("Error Al Obtener Número De Dispositivos\n\n");
  }

  return num_devices;
}

cl_device_id create_device (cl_platform_id platform_id) {
  cl_uint err;
  cl_device_id device_id;

  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 1, &device_id, NULL);

  if (err == CL_SUCCESS) {
    printf ("Dispositivo Creado Exitosamente: Id -> %u\n\n", device_id);
  } else {
    printf ("Error Al Crear Dispositivo!\n\n");
  }

  return device_id;
}

cl_context create_context (cl_device_id device_id) {
  cl_int err;
  cl_context context;

  context = clCreateContext (NULL, 1, &device_id, NULL, NULL, &err);

  if (err == CL_SUCCESS) {
    printf ("Contexto Creado Exitosamente\n\n");
  } else {
    printf ("Error Al Crear Contexto\n\n");
  }

  return context;
}

cl_program create_program (cl_context context, const char* program_source) {
  cl_int err;
  cl_program program;

  program = clCreateProgramWithSource (context, 1, (const char **) &program_source, NULL, &err);

  if (err == CL_SUCCESS) {
    printf ("Programa Creado Exitosamente\n\n");
  } else {
    printf ("Error Al Crear Programa\n\n");
  }

  return program;
}

void build_program (cl_program program, cl_device_id device_id) {
  cl_int err;

  err = clBuildProgram (program, 1, &device_id, NULL, NULL, NULL);

  if (err == CL_SUCCESS){
    printf ("Programa Compilado Exitosamente\n\n");
  } else {
    printf ("Error Al Compilar Programa\n\n");
  }
}

cl_kernel create_kernel (cl_program program) {
  cl_int err;
  cl_kernel kernel;

  kernel = clCreateKernel (program, "vecadd", &err);

  if (err == CL_SUCCESS) {
    printf ("Kernel Creado Exitosamente\n\n");
  } else {
    printf ("Error Al Crear Kernel\n\n");
  }

  return kernel;
}

void print_memory_object (int *array, int length, const char *name) {
  int i;

  printf ("%s = [", name);
  for (i = 0; i < length - 1; i++) {
    printf ("%d, ", array[i]);
  }
  printf ("%d]\n", array[length - 1]);
}

int* create_memory_object (int length, const char *name) {
  int i;
  int *array;

  array = (int *) calloc (length, sizeof (int));

  if (array != NULL) {
    printf ("Arreglo De Datos Creado Exitosamente\n\n");
  } else {
    printf ("Error Al Crear Arreglo De Datos\n\n");
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
    printf ("Buffer %s Creado Exitosamente\n\n", name);
  } else {
    printf ("Error Al Crear Buffer\n\n");
  }

  return array;
}

void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char * arg_name) {
  cl_int err;

  err = clSetKernelArg (kernel, arg_num, sizeof (cl_mem), &arg);

  if (err == CL_SUCCESS) {
    printf ("Argumento De Kernel %s Configurado Exitosamente\n\n", arg_name);
  } else {
    printf ("Error Al Configurar Argumento De Kernel\n\n");
  }
}

cl_command_queue create_command_queue (cl_context context, cl_device_id device_id) {
  cl_int err;
  cl_command_queue command_queue;

  command_queue = clCreateCommandQueue (context, device_id, 0, &err);

  if (err == CL_SUCCESS) {
    printf ("Cola De Comandos Creada Exitosamente\n\n");
  } else {
    printf ("Error Al Crear Cola De Comandos\n\n");
  }

  return command_queue;
}

void enqueue_write_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name) {
  cl_int err;

  err = clEnqueueWriteBuffer (command_queue, buffer, CL_TRUE, 0, sizeof (int) * length, array, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf ("Buffer %s Copiado Exitosamente Al Dispositivo\n\n", name);
  } else {
    printf ("Error Al Copiar Buffer Al Dispositivo\n\n");
  }
}

void enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int length) {
  cl_int err;
  size_t local = length;
  size_t global = length;

  err = clEnqueueNDRangeKernel (command_queue, kernel, 1, NULL, &global, &local, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf ("Kernel Enviado Al Dispositivo Exitosamente\n\n");
  } else {
    printf ("Error Al Enviar Kernel Al Dispositivo\n\n");
  }
}

void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name) {
  cl_int err;

  err = clEnqueueReadBuffer (command_queue, buffer, CL_TRUE, 0, sizeof (int) * length, array, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf ("Buffer %s Copiado Exitosamente Desde El Dispositivo\n\n", name);
  } else {
    printf ("Error Al Copiar Buffer Desde El Dispositivo\n\n");
  }
}

char * readKernel(void) {
  size_t *source_length;
  FILE *fp = fopen("kernel.cl", "r");

  if (fp == NULL) {
    printf("Cannot Open Kernel.cl\n");
  } else {
    printf("Kernel.cl Opened\n");
  }

  fseek(fp, 0, SEEK_END);
  source_length[0] = ftell(fp);
   
  if (source_length[0] == 0) {
    printf("Kernel.cl is empty\n");
  } else {
    printf("Kernel.cl length: %zu bytes\n", source_length[0]);
  }

  char *source = (char*) calloc(source_length[0] + 1, 1);
  if (source == 0) {
    printf("Memory allocation failed");
  }

  fseek(fp, 0, SEEK_SET);
  fread(source, 1, source_length[0], fp);
  printf("Kernel.cl Read\n");
   
  return source;
}
