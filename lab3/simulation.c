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
  int iterations = 0, matrix_size = 0, heat_sources = 0,
    operands = 0, row = 0, err = 0, comm_sz = 0, my_rank = 0,
    local_n = 0, index = 0, i = 0, j = 0, col = 0,
    *heats_x = NULL, *heats_y = NULL;

  float *heats_temperatures = NULL, *matrix = NULL,
    *top_row = NULL, *bottom_row = NULL, accum = 0.0,
    *temp = NULL;

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
      scanf ("%d %d %f", heats_y + j, heats_x + j, heats_temperatures + j);
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
  temp = (float *) calloc (local_n, sizeof (float));

  /* Identify heat sources for current process */
  for (j = 0; j < heat_sources; j++) {
    if (my_rank * matrix_size / comm_sz <= heats_x[j] &&
        heats_x[j] < (my_rank + 1) * matrix_size / comm_sz) {
      index = heats_x[j] * matrix_size + heats_y[j] - my_rank * local_n;
      matrix[index] = heats_temperatures[j];
    }
  }

  top_row = (float *) calloc (matrix_size, sizeof (float));
  assert (top_row != NULL);
  bottom_row = (float *) calloc (matrix_size, sizeof (float));
  assert (bottom_row != NULL);

  for (j = 0; j < iterations; j++) {
    if (my_rank != 0) {
      MPI_Send (matrix, matrix_size, MPI_FLOAT, my_rank - 1, 0,
                MPI_COMM_WORLD);
      MPI_Recv (top_row, matrix_size, MPI_FLOAT, my_rank - 1, 0,
                MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    if (my_rank != comm_sz - 1) {
      MPI_Recv (bottom_row, matrix_size, MPI_FLOAT, my_rank + 1, 0,
                MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      MPI_Send (matrix + (matrix_size / comm_sz - 1) * matrix_size,
                matrix_size, MPI_FLOAT, my_rank + 1, 0, MPI_COMM_WORLD);
    }
    for (row = 0; row < matrix_size / comm_sz; row++) {
      for (col = 0; col < matrix_size; col++) {
        accum = matrix[row * matrix_size + col];
        operands = 1;
        if (row != 0) {
          accum += matrix[(row - 1) * matrix_size + col];
          operands++;
        }
        if (row != matrix_size / comm_sz - 1) {
          accum += matrix[(row + 1) * matrix_size + col];
          operands++;
        }
        if (col != 0) {
          accum += matrix[row * matrix_size + col - 1];
          operands++;
        }
        if (col != matrix_size - 1) {
          accum += matrix[row * matrix_size + col + 1];
          operands++;
        }
        if (row == 0 && my_rank != 0) {
          accum += top_row[col];
          operands++;
        }
        if (row == matrix_size / comm_sz - 1 && my_rank != comm_sz - 1) {
          accum += bottom_row[col];
          operands++;
        }
        temp[row * matrix_size + col] = accum / operands;
      }
    }
    for (row = 0; row < matrix_size / comm_sz; row++) {
      for (col = 0; col < matrix_size; col++) {
        matrix[row * matrix_size + col] = temp[row * matrix_size + col];
      }
    }
    for (i = 0; i < heat_sources; i++) {
      if (my_rank * matrix_size / comm_sz <= heats_x[i] &&
          heats_x[i] < (my_rank + 1) * matrix_size / comm_sz) {
        index = heats_x[i] * matrix_size + heats_y[i] - my_rank * local_n;
        matrix[index] = heats_temperatures[i];
      }
    }
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
