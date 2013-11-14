#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <mpi.h>
#include "helpers.h"

int main (void) {
  int iterations = 0, matrix_size = 0, heat_sources = 0,
    err = 0, comm_sz = 0, my_rank = 0, fragment_size = 0, j = 0;
  float *matrix = NULL, *top_row = NULL, *bottom_row = NULL;
  /* double time_init = 0, time_end = 0; */
  heat_t *heats = NULL;

  /* Initialize MPI */
  err = MPI_Init (NULL, NULL);
  /* Get communicator size */
  err |= MPI_Comm_size (MPI_COMM_WORLD, &comm_sz);
  /* Get current process rank */
  err |= MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);

  /* If there's an error return with error code */
  if (err != 0)
    return -1;

  /* time_init = MPI_Wtime (); */

  /* Only process 0 parse STDIN */
  if (my_rank == 0) {
    scanf ("%d", &matrix_size);
    scanf ("%d", &iterations);
    scanf ("%d", &heat_sources);

    /* Adjust matrix_size to be a multiple of comm_sz */
    if (matrix_size % comm_sz != 0)
      matrix_size += comm_sz - matrix_size % comm_sz;
  }

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
  Declare_Heat_T();

  heats = (heat_t *) calloc (heat_sources, sizeof (heat_t));
  assert (heats != NULL);

  /* Process 0 parse heats sources data */
  if (my_rank == 0) {
    for (j = 0; j < heat_sources; j++)
      scanf ("%d %d %f", &((heats + j) -> y), &((heats + j) -> x),
             &((heats + j) -> t));
  }

  /* Process 0 broadcast heats sources data */
  MPI_Bcast (heats, heat_sources, MPI_HEAT_T, 0, MPI_COMM_WORLD);

  /* Fragment of the original matrix */
  matrix = (float *) calloc (fragment_size, sizeof (float));
  /* Memory to hold rows received from other processes in order to
     calculate temperatures for cells on the boundaries */
  top_row = (float *) calloc (matrix_size, sizeof (float));
  bottom_row = (float *) calloc (matrix_size, sizeof (float));

  assert (matrix != NULL);
  assert (top_row != NULL);
  assert (bottom_row != NULL);

  /* Initialize matrices with heat sources */
  reset_sources (heat_sources, my_rank, matrix_size, comm_sz,
                 fragment_size, heats, matrix);

  /* Start iterative computation */
  for (j = 0; j < iterations; j++) {
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
      MPI_Send (matrix + (matrix_size / comm_sz - 1) * matrix_size,
                matrix_size, MPI_FLOAT, my_rank + 1, 0, MPI_COMM_WORLD);
      MPI_Recv (bottom_row, matrix_size, MPI_FLOAT, my_rank + 1, 0,
                MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

    /* Recursive formula applied to modify the matrix */
    transform_matrix (matrix, matrix_size, comm_sz, my_rank, top_row,
                      bottom_row);

    /* Every time the matrix is transformed, all heat sources should
       keep its temperature */
    reset_sources (heat_sources, my_rank, matrix_size, comm_sz,
                   fragment_size, heats, matrix);
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

  MPI_Barrier (MPI_COMM_WORLD);
  /* time_end = MPI_Wtime (); */

  /*
    if (my_rank == 0)
    printf ("Tiempo transcurrido = %.2f\n", time_end - time_init);
  */

  /* MPI API is not necessary anymore */
  MPI_Finalize ();

  /* Free resources allocated */
  free (heats);
  free (matrix);
  free (top_row);
  free (bottom_row);

  return 0;
}
