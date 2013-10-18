#include "helpers.h"

cl_uint get_platforms_number (void) {
  cl_uint err;
  cl_uint num_platforms;

  err = clGetPlatformIDs (0, NULL, &num_platforms);

  if (err == CL_SUCCESS) {
    printf ("Plataformas Disponibles: %u\n", num_platforms);
  } else {
    printf ("Error Al Obtener Número De Plataformas!\n");
  }

  return num_platforms;
}

cl_platform_id create_platform (cl_uint num_platforms) {
  cl_uint err;
  cl_platform_id platform_id;

  err = clGetPlatformIDs (1, &platform_id, &num_platforms);

  if (err == CL_SUCCESS) {
    printf ("Plataforma Creada Exitosamente: Id -> %u\n", platform_id);
  } else {
    printf ("Error Al Crear Plataforma\n");
  }

  return platform_id;
}

cl_uint get_devices_num (cl_platform_id platform_id) {
  cl_uint err;
  cl_uint num_devices;

  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 0, NULL, &num_devices);

  if (err == CL_SUCCESS) {
    printf ("Dispositivos Disponibles: %u \n", num_devices);
  } else {
    printf ("Error Al Obtener Número De Dispositivos!\n");
  }

  return num_devices;
}

cl_device_id create_device (cl_platform_id platform_id) {
  cl_uint err;
  cl_device_id device_id;

  err = clGetDeviceIDs (platform_id, CL_DEVICE_TYPE_ALL, 1, &device_id, NULL);

  if (err == CL_SUCCESS) {
    printf ("Dispositivo Creado Exitosamente: Id -> %u\n", device_id);
  } else {
    printf ("Error Al Crear Dispositivo!\n");
  }

  return device_id;
}

void get_platform_info (cl_platform_id platform_id, cl_platform_info info, const char * attr) {
  cl_uint err;
  char *platform_info;

  platform_info = (char *) calloc (1000, sizeof (char));
  err = clGetPlatformInfo (platform_id, info, 1000 * sizeof (char), platform_info, NULL);

  if (err == CL_SUCCESS) {
    printf ("%s De La Plataforma: %s\n", attr, platform_info);
  } else {
    printf ("Error Al Obtener %s De La Plataforma!\n", attr);
  }
}

char* get_device_name (cl_device_id device_id) {
  cl_uint err;
  char *device_name;

  device_name = (char *) calloc (100, sizeof (char));
  err = clGetDeviceInfo (device_id, CL_DEVICE_NAME, 100 * sizeof (char), device_name, NULL);


  if (err == CL_SUCCESS) {
    printf ("Nombre Del Dispositivo: %s\n", device_name);
  } else {
    printf ("Error Al Obtener El Nombre Del Dispositivo!\n");
  }

  return device_name;
}

cl_context create_context (cl_device_id device_id) {
  cl_int err;
  cl_context context;

  context = clCreateContext (NULL, 1, &device_id, NULL, NULL, &err);

  if (err == CL_SUCCESS) {
    printf ("Contexto Creado Exitosamente\n");
  } else {
    printf ("Error Al Crear Contexto\n");
  }

  return context;
}

const char* get_program_source (void) {
  return
    "__kernel                      \n"
    "void vecadd (__global int *A, \n"
    "             __global int *B, \n"
    "             __global int *C) \n"
    "{                             \n"
    "  int tid = get_global_id(0); \n"
    "  C[tid] = A[tid] + B[tid];   \n"
    "}                             \n";
}

cl_program create_program (cl_context context, const char* program_source) {
  cl_int err;
  cl_program program;

  program = clCreateProgramWithSource (context, 1, (const char **) &program_source, NULL, &err);

  if (err == CL_SUCCESS) {
    printf ("Programa Creado Exitosamente\n");
  } else {
    printf ("Error Al Crear Programa\n");
  }

  return program;
}

void build_program (cl_program program, cl_device_id device_id) {
  cl_int err;

  err = clBuildProgram (program, 1, &device_id, NULL, NULL, NULL);

  if (err == CL_SUCCESS){
    printf ("Programa Compilado Exitosamente\n");
  } else {
    printf ("Error Al Compilar Programa\n");
  }
}

cl_kernel create_kernel (cl_program program) {
  cl_int err;
  cl_kernel kernel;

  kernel = clCreateKernel (program, "vecadd", &err);

  if (err == CL_SUCCESS) {
    printf ("Kernel Creado Exitosamente\n");
  } else {
    printf ("Error Al Crear Kernel\n");
  }

  return kernel;
}

void print_memory_object (int *array, int length, const char *name) {
  int i;

  printf("%s = [", name);
  for (i = 0; i < length - 1; i++) {
    printf ("%d, ", array[i]);
  }
  printf("%d]\n", array[length - 1]);
}

int* create_memory_object (int length, const char *name) {
  int i;
  int *array;

  array = (int *) calloc (length, sizeof (int));

  if (array != NULL) {
    printf ("Arreglo De Datos Creado Exitosamente\n");
  } else {
    printf ("Error Al Crear Arreglo De Datos\n");
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
    printf ("Buffer %s Creado Exitosamente\n", name);
  } else {
    printf ("Error Al Crear Buffer\n");
  }

  return array;
}

void set_kernel_argument (cl_kernel kernel, cl_mem arg, int arg_num, const char * arg_name) {
  cl_int err;

  err = clSetKernelArg (kernel, arg_num, sizeof (cl_mem), &arg);

  if (err == CL_SUCCESS) {
    printf ("Argumento De Kernel %s Configurado Exitosamente\n", arg_name);
  } else {
    printf ("Error Al Configurar Argumento De Kernel\n");
  }
}

cl_command_queue create_command_queue (cl_context context, cl_device_id device_id) {
  cl_int err;
  cl_command_queue command_queue;

  command_queue = clCreateCommandQueue (context, device_id, 0, &err);

  if (err == CL_SUCCESS) {
    printf ("Cola De Comandos Creada Exitosamente\n");
  } else {
    printf ("Error Al Crear Cola De Comandos\n");
  }

  return command_queue;
}

void enqueue_write_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name) {
  cl_int err;

  err = clEnqueueWriteBuffer (command_queue, buffer, CL_TRUE, 0, sizeof (int) * length, array, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf ("Buffer %s Copiado Exitosamente Al Dispositivo\n", name);
  } else {
    printf ("Error Al Copiar Buffer Al Dispositivo\n");
  }
}

void enqueue_kernel_execution (cl_command_queue command_queue, cl_kernel kernel, int length) {
  cl_int err;
  size_t local = length;
  size_t global = length;

  err = clEnqueueNDRangeKernel (command_queue, kernel, 1, NULL, &global, &local, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf ("Kernel Enviado Al Dispositivo Exitosamente\n");
  } else {
    printf ("Error Al ENviar Kernel Al Dispositivo\n");
  }
}

void enqueue_read_buffer_task (cl_command_queue command_queue, cl_mem buffer, int length, int *array, const char* name) {
  cl_int err;

  err = clEnqueueReadBuffer (command_queue, buffer, CL_TRUE, 0, sizeof (int) * length, array, 0, NULL, NULL);

  if (err == CL_SUCCESS) {
    printf ("Buffer %s Copiado Exitosamente Desde El Dispositivo\n", name);
  } else {
    printf ("Error Al Copiar Buffer Desde El Dispositivo\n");
  }
}

void print_platform_information (cl_platform_id platform_id) {
  get_platform_info (platform_id, CL_PLATFORM_NAME, "Nombre");
  get_platform_info (platform_id, CL_PLATFORM_PROFILE, "Perfil");
  get_platform_info (platform_id, CL_PLATFORM_VERSION, "Versión");
  get_platform_info (platform_id, CL_PLATFORM_VENDOR, "Fabricante");
  get_platform_info (platform_id, CL_PLATFORM_EXTENSIONS, "Extensiones");
}
