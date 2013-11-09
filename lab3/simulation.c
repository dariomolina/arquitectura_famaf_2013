#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <mpi.h>

int main (void) {
  int iterations = 0, matrix_size = 0, heat_sources = 0,
    err = 0, comm_sz = 0, my_rank = 0, fragment_size = 0,
    j = 0, *heats_x = NULL, *heats_y = NULL;

  float *heats_temperatures = NULL, *matrix = NULL,
    *top_row = NULL, *bottom_row = NULL;

  /* Initialize MPI */
  err = MPI_Init (NULL, NULL);
  /* Get communicator size */
  err |= MPI_Comm_size (MPI_COMM_WORLD, &comm_sz);
  /* Get current process rank */
  err |= MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);

  /* If there's an error return with error code */
  if (err != 0)
    return -1;

  /* Only process 0 parse STDIN */
  if (my_rank == 0) {
    scanf ("%d", &matrix_size);
    scanf ("%d", &iterations);
    scanf ("%d", &heat_sources);
  }

  /* Adjust matrix_size to be a multiple of comm_sz */
  if (matrix_size % comm_sz != 0)
    matrix_size += comm_sz - matrix_size % comm_sz;

  /* Process 0 broadcast the input parsed to all processes,
   each process should know the matrix size for different
   calculations, how many iterations each process should perform,
   and how many heat sources there exists */
  MPI_Bcast (&matrix_size, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (&iterations, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (&heat_sources, 1, MPI_INT, 0, MPI_COMM_WORLD);

  /* Each process work over a fragment of the whole matrix,
     the matrix is partitioned on equally-sized portions */
  fragment_size = (matrix_size * matrix_size) / comm_sz;

  /* Each process will have a copy of the heats data, this data
     includes x coordinates, y coordinates & temperatures */
  heats_x = (int *) calloc (heat_sources, sizeof (int));
  heats_y = (int *) calloc (heat_sources, sizeof (int));
  heats_temperatures = (float *) calloc (heat_sources, sizeof (float));

  assert (heats_x != NULL);
  assert (heats_y != NULL);
  assert (heats_temperatures != NULL);

  /* Process 0 parse heats sources data */
  if (my_rank == 0) {
    for (j = 0; j < heat_sources; j++)
      scanf ("%d %d %f", heats_y + j, heats_x + j, heats_temperatures + j);
  }

  /* Process 0 broadcast heats sources data */
  MPI_Bcast (heats_x, heat_sources, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (heats_y, heat_sources, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast (heats_temperatures, heat_sources, MPI_FLOAT, 0, MPI_COMM_WORLD);

  /* Fragment of the original matrix */
  matrix = (float *) calloc (fragment_size, sizeof (float));
  /* Memory to hold rows received from other processes in order to
     calculate temperatures for cells on the boundaries */
  top_row = (float *) calloc (matrix_size, sizeof (float));
  bottom_row = (float *) calloc (matrix_size, sizeof (float));

  assert (matrix != NULL);
  assert (top_row != NULL);
  assert (bottom_row != NULL);

  /* Start iterative computation */
  for (j = 0; j < iterations; j++) {
    /* Every time the matrix is transformed, all heat sources should
       keep its temperature, and for the first run, it's an initialization */
    reset_sources (heat_sources, my_rank, matrix_size, comm_sz,
                   fragment_size, heats_x, heats_y,
                   heats_temperatures, matrix);

    /* Process 0 don't receive a row from a process "above", neither
       it should send its first row */
    if (my_rank != 0) {
      MPI_Send (matrix, matrix_size, MPI_FLOAT, my_rank - 1, 0,
                MPI_COMM_WORLD);
      MPI_Recv (top_row, matrix_size, MPI_FLOAT, my_rank - 1, 0,
                MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

    /* Process comm_sz - 1 don't receive a row from a process "below", neither
       it should send its last row */
    if (my_rank != comm_sz - 1) {
      MPI_Recv (bottom_row, matrix_size, MPI_FLOAT, my_rank + 1, 0,
                MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      MPI_Send (matrix + (matrix_size / comm_sz - 1) * matrix_size,
                matrix_size, MPI_FLOAT, my_rank + 1, 0, MPI_COMM_WORLD);
    }

    /* Recursive formula applied to modify the matrix */
    transform_matrix (matrix, matrix_size, comm_sz, my_rank, top_row,
                      bottom_row);
  }

  /* Process 0 is in charge of printing the whole matrix to STDOUT,
     thus it should print its fragment of the matrix, and all other
     processes should send its fragment to process 0 */
  if (my_rank == 0) {
    print_matrix (matrix, matrix_size / comm_sz, matrix_size);
    /* Receive fragments from other processes & print */
    for (j = 1; j < comm_sz; j++) {
      MPI_Recv (matrix, fragment_size, MPI_FLOAT, j, 0, MPI_COMM_WORLD,
                MPI_STATUS_IGNORE);
      print_matrix (matrix, matrix_size / comm_sz, matrix_size);
    }
  } else {
    /* Send fragment to process 0*/
    MPI_Send (matrix, fragment_size, MPI_FLOAT, 0, 0, MPI_COMM_WORLD);
  }

  /* MPI API is not necessary anymore */
  MPI_Finalize ();

  /* Free resources allocated */
  free (heats_x);
  free (heats_y);
  free (heats_temperatures);
  free (matrix);
  free (top_row);
  free (bottom_row);

  return 0;
}
