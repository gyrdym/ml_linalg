import 'matrix/float32/matrix_initializing/float32_matrix_from_columns.dart';
import 'matrix/float32/matrix_initializing/float32_matrix_from_flattened.dart';
import 'matrix/float32/matrix_initializing/float32_matrix_from_list.dart';
import 'matrix/float32/matrix_initializing/float32_matrix_from_rows.dart';
import 'vector/float32/vector_initializing/float32x4_from_list.dart';
import 'vector/float32/vector_initializing/float32x4_random_filled.dart';
import 'vector/float32/vector_operations/float32x4_vector_abs.dart';
import 'vector/float32/vector_operations/float32x4_vector_equality_operator.dart';
import 'vector/float32/vector_operations/float32x4_vector_hash_code.dart';
import 'vector/float32/vector_operations/float32x4_vector_indexed_access_operator.dart';
import 'vector/float32/vector_operations/float32x4_vector_max.dart';
import 'vector/float32/vector_operations/float32x4_vector_min.dart';
import 'vector/float32/vector_operations/float32x4_vector_norm.dart';
import 'vector/float32/vector_operations/float32x4_vector_scalar_addition.dart';
import 'vector/float32/vector_operations/float32x4_vector_scalar_division.dart';
import 'vector/float32/vector_operations/float32x4_vector_scalar_multiplication.dart';
import 'vector/float32/vector_operations/float32x4_vector_scalar_subtraction.dart';
import 'vector/float32/vector_operations/float32x4_vector_sqrt.dart';
import 'vector/float32/vector_operations/float32x4_vector_sum.dart';
import 'vector/float32/vector_operations/float32x4_vector_pow.dart';
import 'vector/float32/vector_operations/float32x4_vector_unique.dart';
import 'vector/float32/vector_operations/float32x4_vector32_vector32_addition.dart';
import 'vector/float32/vector_operations/float32x4_vector32_vector32_multiplication.dart';

void main() {
  // Vector's benchmarks

  // Vector's constructor
  Float32x4VectorFromListBenchmark.main();
  Float32x4VectorRandomFilledBenchmark.main();

  // Vector's methods and operators
  Float32x4VectorAbsBenchmark.main();
  Float32x4VectorHashCodeBenchmark.main();
  Float32x4VectorPowBenchmark.main();
  Float32x4VectorMaxValueBenchmark.main();
  Float32x4VectorMinValueBenchmark.main();
  Float32x4VectorNormBenchmark.main();
  Float32x4VectorRandomAccessBenchmark.main();
  Float32x4VectorAndScalarDivisionBenchmark.main();
  Float32x4VectorAndScalarAdditionBenchmark.main();
  Float32x4VectorAndVectorAdditionBenchmark.main();
  Float32x4VectorAndScalarSubtractionBenchmark.main();
  Float32x4VectorAndScalarMultiplicationBenchmark.main();
  Float32x4VectorAndVectorMultiplicationBenchmark.main();
  Float32x4VectorSqrtBenchmark.main();
  Float32x4VectorSumBenchmark.main();
  Float32x4VectorUniqueBenchmark.main();
  Float32x4VectorEqualityOperatorBenchmark.main();

  // Matrix benchmarks
  Float32MatrixFromColumnsBenchmark.main();
  Float32MatrixFromFlattenedBenchmark.main();
  Float32MatrixFromListBenchmark.main();
  Float32MatrixFromRowsBenchmark.main();
}
