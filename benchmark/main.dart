import 'vector_initializing/float32x4_from_iterable.dart';
import 'vector_operations/float32x4_unique.dart';
import 'vector_operations/float32x4_vectors_multiplication.dart';
import 'vector_operations/float32x4_vectors_sum.dart';

void main() {
  VectorInitializationBenchmark.main();
  VectorUniqueBenchmark.main();
  VectorMulBenchmark.main();
  VectorAdditionBenchmark.main();
}
