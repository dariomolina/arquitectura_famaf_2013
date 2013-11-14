#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stddef.h>
#include "helpers.h"

void Declare_Heat_T (void) {
  int blocklengths[] = {1, 1, 1};

  MPI_Aint displacements[] = {
    offsetof (heat_t, x),
    offsetof (heat_t, y),
    offsetof (heat_t, t)
  };

  MPI_Datatype types[] = {MPI_INT, MPI_INT, MPI_DOUBLE};
  MPI_Type_create_struct (3, blocklengths, displacements, types, &MPI_HEAT_T);
  MPI_Type_commit (&MPI_HEAT_T);
}

/* Pretty (not that pretty) printer for matrices */
void print_matrix (float *matrix, int rows_count, int row_size) {
  int i = 0, j = 0;

  for (i = 0; i < rows_count; i++) {
    for (j = 0; j < row_size; j++) {
      printf ("%.2f ", matrix[i * row_size + j]);
    }
    printf ("\n");
  }
}

void reset_sources (int heat_sources, int my_rank, int matrix_size, int comm_sz,
                    int fragment_size, heat_t heats[], float matrix[]) {
  int j = 0, index = 0;

  /* Check for each heat source */
  for (j = 0; j < heat_sources; j++) {
    /* Current process covers rows of the original matrix ranging
       form my_rank * matrix_size / comm_sz to
       (my_rank + 1) * matrix_size / comm_sz - 1.
       So current process should take into consideration only those
       heat sources whose x coordinate is within that range */
    if (my_rank * matrix_size / comm_sz <= (heats + j) -> x &&
        (heats + j) -> x < (my_rank + 1) * matrix_size / comm_sz) {
      index = (heats + j) -> x * matrix_size + (heats + j) -> y - my_rank * fragment_size;
      matrix[index] = (heats + j) -> t;
    }
  }
}

void transform_matrix (float matrix[], int matrix_size, int comm_sz,
                       int my_rank, float top_row[], float bottom_row[]) {
  float accum = 0, *temp = NULL;
  int row = 0, col = 0, operands = 0, fragment_size = 0;

  /* Each process work over a fragment of the whole matrix,
     the matrix is partitioned on equally-sized portions */
  fragment_size = (matrix_size * matrix_size) / comm_sz;

  temp = (float *) calloc (fragment_size, sizeof (float));
  assert (temp != NULL);

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

  /* Replace old matrix values with the new ones */
  for (row = 0; row < matrix_size / comm_sz; row++) {
    for (col = 0; col < matrix_size; col++) {
      matrix[row * matrix_size + col] = temp[row * matrix_size + col];
    }
  }

  free (temp);
}
