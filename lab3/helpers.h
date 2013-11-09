#ifndef HELPERS_H
#define HELPERS_H

void print_matrix (float *matrix, int rows_count, int row_size);

void reset_sources (int heat_sources, int my_rank, int matrix_size,
                    int comm_sz, int fragment_size, int heats_x[],
                    int heats_y[], float heats_temperatures[],
                    float matrix[]);

float *transform_matrix (float matrix[], int matrix_size, int comm_sz,
                         int my_rank, int heat_sources, int heats_x[],
                         int heats_y[], float heats_temperatures[],
                         float top_row[], float bottom_row[]);

#endif /* HELPERS_H */
