#ifndef HELPERS_H
#define HELPERS_H

#include <mpi.h>

typedef struct s_heat_t {
	int x, y;
	float t;
} heat_t;

MPI_Datatype MPI_HEAT_T;

void Declare_Heat_T (void);

void print_matrix (float *matrix, int rows_count, int row_size);

void reset_sources (int heat_sources, int my_rank, int matrix_size,
                    int comm_sz, int fragment_size, heat_t heats[],
                    float matrix[]);

void transform_matrix (float matrix[], int matrix_size, int comm_sz,
                       int my_rank, float top_row[], float bottom_row[]);

#endif /* HELPERS_H */
