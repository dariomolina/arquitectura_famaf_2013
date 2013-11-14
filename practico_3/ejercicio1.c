#include <stdio.h>
#include <mpi.h>

static void get_input (double *a, double *b, int *n,
                       int my_rank, int comm_sz) {
  if (my_rank == 0) {
    printf ("Ingrese los extremos del intervalo");
    printf (" y el tamaño de la partición\n");
    scanf ("%lf %lf %d", a, b, n);
  }

  if (*n % comm_sz != 0)
    *n += comm_sz - *n % comm_sz;

  MPI_Bcast (a, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast (b, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast (n, 1, MPI_INT, 0, MPI_COMM_WORLD);
}

static double function (double x) {
  return x * x;
}

static double Trap (double local_a, double local_b, double h,
                    int my_rank, int comm_sz) {
  double x = 0.0, local_int = 0.0;

  x = local_a;
  while (x <= local_b) {
    local_int += function (x);
    x += h;
  }

  if (my_rank == 0)
    local_int -= function (local_a) / 2;
  else if (my_rank == comm_sz - 1)
    local_int -= function (local_b) / 2;

  local_int *= h;

  return local_int;
}

int main (void) {
  double a = 0.0, b = 0.0, local_int = 0.0, total_int = 0.0, h = 0.0,
    local_a = 0.0, local_b = 0.0;
  int my_rank = 0, comm_sz = 0, err = 0, n = 0, local_n = 0;

  err = MPI_Init (NULL, NULL);
  err |= MPI_Comm_size (MPI_COMM_WORLD, &comm_sz);
  err |= MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);

  if (err != 0)
    return -1;

  get_input (&a, &b, &n, my_rank, comm_sz);

  h = (b - a) / n;
  local_n = n / comm_sz;
  local_a = a + h * local_n * my_rank;
  local_b = local_a + h * local_n;

  local_int = Trap (local_a, local_b, h, my_rank, comm_sz);

  MPI_Reduce (&local_int, &total_int, 1,
              MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

  if (my_rank == 0) {
    printf ("El valor de la integral entre %.2f y %.2f ", a, b);
    printf ("con tamaño de partición %d es %.10f\n", n, total_int);
  }

  MPI_Finalize ();

  return 0;
}
