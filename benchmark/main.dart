import 'matrix/matrix_initializing/float32_from_columns.dart';
import 'matrix/matrix_initializing/float32_from_flattened.dart';
import 'matrix/matrix_initializing/float32_from_list.dart';
import 'matrix/matrix_initializing/float32_from_rows.dart';
import 'vector/vector_initializing/float32x4_from_list.dart';
import 'vector/vector_initializing/float32x4_random_filled.dart';
import 'vector/vector_operations/float32x4_vector_abs.dart';
import 'vector/vector_operations/float32x4_vector_equality_operator.dart';
import 'vector/vector_operations/float32x4_vector_hash_code.dart';
import 'vector/vector_operations/float32x4_vector_indexed_access_operator.dart';
import 'vector/vector_operations/float32x4_vector_max.dart';
import 'vector/vector_operations/float32x4_vector_min.dart';
import 'vector/vector_operations/float32x4_vector_norm.dart';
import 'vector/vector_operations/float32x4_vector_scalar_addition.dart';
import 'vector/vector_operations/float32x4_vector_scalar_division.dart';
import 'vector/vector_operations/float32x4_vector_scalar_multiplication.dart';
import 'vector/vector_operations/float32x4_vector_scalar_subtraction.dart';
import 'vector/vector_operations/float32x4_vector_sqrt.dart';
import 'vector/vector_operations/float32x4_vector_sum.dart';
import 'vector/vector_operations/float32x4_vector_to_integer_power.dart';
import 'vector/vector_operations/float32x4_vector_unique.dart';
import 'vector/vector_operations/float32x4_vector_vector_addition.dart';
import 'vector/vector_operations/float32x4_vector_vector_multiplication.dart';

void main() {
  // Vector's benchmarks

  // Vector's constructor
  Float32x4VectorFromListBenchmark.main();
  Float32x4VectorRandomFilledBenchmark.main();

  // Vector's methods and operators
  Float32x4VectorAbsBenchmark.main();
  Float32x4VectorHashCodeBenchmark.main();
  Float32x4VectorToIntegerPowerBenchmark.main();
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
  Float32x4MatrixFromColumnsBenchmark.main();
  Float32x4MatrixFromFlattenedBenchmark.main();
  Float32x4MatrixFromListBenchmark.main();
  Float32x4MatrixFromRowsBenchmark.main();
}
