#include "helpers.h"

int main (void) {
  char name[500];
  int device_index = 0;
  cl_uint num_devices = 0;
  cl_platform_id platform_id = 0;
  cl_device_id *devices_ids = NULL;
  cl_ulong performance = 0, acc = 0;

  get_platforms_number ();
  platform_id = get_platform ();
  print_platform_information (platform_id);
  num_devices = get_devices_num (platform_id);
  devices_ids = get_devices_ids (platform_id, num_devices);

  for (int i = 0; i < num_devices; i++) {
    performance = device_information (devices_ids[i], i);
    if (acc < performance) {
      acc = performance;
      device_index = i;
    }
  }

  clGetDeviceInfo (devices_ids[device_index], CL_DEVICE_NAME, 500, name, NULL);
  printf (ANSI_COLOR_CYAN "Dispositivo con mejor performance: %s\n\n" ANSI_COLOR_RESET, name);

  return 0;
}
