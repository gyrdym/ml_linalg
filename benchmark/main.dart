import 'vector/vector_initializing/float32x4_from_list.dart';
import 'vector/vector_operations/float32x4_unique.dart';
import 'vector/vector_operations/float32x4_vectors_multiplication.dart';
import 'vector/vector_operations/float32x4_vectors_sum.dart';

void main() {
  VectorInitializationBenchmark.main();
  VectorUniqueBenchmark.main();
  VectorMulBenchmark.main();
  VectorAdditionBenchmark.main();
}
