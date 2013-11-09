#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <mpi.h>

void print_matrix (float *matrix, int rows_count, int row_size) {
  int i = 0, j = 0;

  for (i = 0; i < rows_count; i++) {
    for (j = 0; j < row_size; j++) {
      printf ("%.2f ", matrix[i * row_size + j]);
    }
    printf ("\n");
  }
}

int main (void) {
  int iterations = 0, matrix_size = 0, heat_sources = 0, j = 0;
  int err = 0, comm_sz = 0, my_rank = 0, local_n = 0, index = 0;

  int *heats_x = NULL, *heats_y = NULL;
  float *heats_temperatures = NULL, *matrix = NULL;

  err = MPI_Init (NULL, NULL);
  err |= MPI_Comm_size (MPI_COMM_WORLD, &comm_sz);
  err |= MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);

  if (err != 0)
    return -1;

  if (my_rank == 0) {
    scanf ("%d", &matrix_size);
    scanf ("%d", &iterations);
    scanf ("%d", &heat_sources);
  }

  /* Broadcast information obtained by process 0 */
  MPI_Bcast (&matrix_size, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (&iterations, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (&heat_sources, 1, MPI_INT, 0, MPI_COMM_WORLD);

  /* first coordinate of each heat */
  heats_x = (int *) calloc (heat_sources, sizeof (int));
  assert (heats_x != NULL);

  /* second coordinate of each heat */
  heats_y = (int *) calloc (heat_sources, sizeof (int));
  assert (heats_y != NULL);

  /* temperature of each heat */
  heats_temperatures = (float *) calloc (heat_sources, sizeof (float));
  assert (heats_temperatures != NULL);

  if (my_rank == 0) {
    for (j = 0; j < heat_sources; j++)
      scanf ("%d %d %f", heats_x + j, heats_y + j, heats_temperatures + j);
  }

  /* Only process 0 get input from STDIN, so broadcast info obtained */
  MPI_Bcast (heats_x, heat_sources, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (heats_y, heat_sources, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (heats_temperatures, heat_sources, MPI_FLOAT, 0, MPI_COMM_WORLD);

  /* Number of matrix elements per process */
  local_n = (matrix_size * matrix_size) / comm_sz;
  /* Allocate memory for portion of matrix to be processed by
   current process */
  matrix = (float *) calloc (local_n, sizeof (float));

  /* Identify heat sources for current process */
  for (j = 0; j < heat_sources; j++) {
    if (my_rank * matrix_size / comm_sz <= heats_x[j] &&
        heats_x[j] < (my_rank + 1) * matrix_size / comm_sz) {
      index = heats_x[j] * matrix_size + heats_y[j] - my_rank * local_n;
      matrix[index] = heats_temperatures[j];
    }
  }

  for (j = 0; j < iterations; j++) {
    /* calculo de cada iteracion */
  }

  if (my_rank == 0) {
    /* Print portion of matrix processed by process 0 */
    print_matrix (matrix, matrix_size / comm_sz, matrix_size);
    for (j = 1; j < comm_sz; j++) {
      /* Receive & Print portion of matrix processed by process j */
      MPI_Recv (matrix, local_n, MPI_FLOAT, j, 0, MPI_COMM_WORLD,
                MPI_STATUS_IGNORE);
      print_matrix (matrix, matrix_size / comm_sz, matrix_size);
    }
  } else { /* my_rank != 0 */
    /* Send portion of matrix proccessed to process 0, only process 0
     writes to STDOUT */
    MPI_Send (matrix, local_n, MPI_FLOAT, 0, 0, MPI_COMM_WORLD);
  }

  /* MPI API is not used anymore */
  MPI_Finalize ();

  return 0;
}
