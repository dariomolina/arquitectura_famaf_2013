#include "helpers.h"

int main (void) {
  cl_uint dev_number = 0;
  cl_platform_id platform_id = 0;

  /* number of platforms on the system */
  platforms_number ();

  /* id of the first platform proposed by the system */
  platform_id = get_platform ();

  /* information about the platform specified by platform_id */
  platform_information (platform_id);

  /* number of devices on the platform specified by platform_id */
  dev_number = devices_number (platform_id);

  /* information about all devices on the platform specified by
     platform_id, number of devices on the platform should be specified */
  devices_information (devices_ids (platform_id, dev_number), dev_number);

  return 0;
}
