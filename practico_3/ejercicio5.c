#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <mpi.h>

static int dot_product (int local_a[], int local_b[], int size) {
  int i = 0, result = 0;

  assert (size > 0);
  for (i = 0; i < size; i++)
    result += local_a[i] * local_b[i];

  return result;
}

static void print_vector (int *vector, int size) {
  int i = 0;

  assert (size > 0);
  printf ("[");
  for (i = 0; i < size - 1; i++)
    printf ("%d, ", vector[i]);
  printf ("%d]\n\n", vector[size - 1]);
}

static void read_vector_size (int *size, int my_rank) {
  if (my_rank == 0) {
    printf ("Ingrese el tamaño de los vectores\n");
    scanf ("%d", size);
  }

  MPI_Bcast (size, 1, MPI_INT, 0, MPI_COMM_WORLD);
}

static void read_vector (int *local_a, int *local_b,
                         int local_n, int global_n, int my_rank) {
  int i = 0, *global_a = NULL, *global_b = NULL;

  if (my_rank == 0) {
    global_a = (int *) calloc (global_n, sizeof (int));
    global_b = (int *) calloc (global_n, sizeof (int));

    for (i = 0; i < global_n; i++) {
      global_a[i] = (int) rand () % 10;
      global_b[i] = (int) rand () % 10;
    }

    printf ("\nEl vector a es\n");
    print_vector (global_a, global_n);
    printf ("\nEl vector b es\n");
    print_vector (global_b, global_n);
  }

  MPI_Scatter (global_a, local_n, MPI_INT,
               local_a, local_n, MPI_INT,
               0, MPI_COMM_WORLD);
  MPI_Scatter (global_b, local_n, MPI_INT,
               local_b, local_n, MPI_INT,
               0, MPI_COMM_WORLD);

  if (global_a != NULL) free (global_a);
  if (global_b != NULL) free (global_b);
}

int main (void) {
  int *local_a = NULL, *local_b = NULL, comm_sz = 0, my_rank = 0,
    err = 0, local_n = 0, global_n = 0, local_dot_prod = 0,
    global_dot_prod = 0;

  err = MPI_Init (NULL, NULL);
  err |= MPI_Comm_size (MPI_COMM_WORLD, &comm_sz);
  err |= MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);

  if (err != 0)
    return -1;

  read_vector_size (&global_n, my_rank);
  local_n = global_n / comm_sz;
  local_a = (int *) calloc (local_n, sizeof (int));
  local_b = (int *) calloc (local_n, sizeof (int));

  read_vector (local_a, local_b, local_n, global_n, my_rank);
  local_dot_prod = dot_product (local_a, local_b, local_n);

  MPI_Reduce (&local_dot_prod, &global_dot_prod, 1,
              MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

  if (my_rank == 0) {
    printf ("El producto punto es %d\n", global_dot_prod);
  }

  free (local_a);
  free (local_b);
}
