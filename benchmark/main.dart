import 'matrix/matrix_initializing/float32_from_columns.dart';
import 'matrix/matrix_initializing/float32_from_flattened.dart';
import 'matrix/matrix_initializing/float32_from_list.dart';
import 'matrix/matrix_initializing/float32_from_rows.dart';
import 'vector/vector_initializing/float32_from_list.dart';
import 'vector/vector_initializing/float32_random_filled.dart';
import 'vector/vector_operations/float32_vector_max.dart';
import 'vector/vector_operations/float32_vector_random_access.dart';
import 'vector/vector_operations/float32_vector_unique.dart';
import 'vector/vector_operations/float32_vectors_add.dart';
import 'vector/vector_operations/float32_vectors_equality.dart';
import 'vector/vector_operations/float32_vectors_multiplication.dart';

void main() {
  // Vector's benchmarks
  VectorFromListBenchmark.main();
  VectorRandomFilledBenchmark.main();
  VectorMaxValueBenchmark.main();
  VectorRandomAccessBenchmark.main();
  VectorUniqueBenchmark.main();
  VectorAdditionBenchmark.main();
  VectorsEqualityBenchmark.main();
  VectorMulBenchmark.main();

  // Matrix benchmarks
  Float32x4MatrixFromColumnsBenchmark.main();
  Float32x4MatrixFromFlattenedBenchmark.main();
  Float32x4MatrixFromListBenchmark.main();
  Float32x4MatrixFromRowsBenchmark.main();
}
