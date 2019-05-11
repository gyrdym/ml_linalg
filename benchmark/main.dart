import 'vector/vector_initializing/float32_from_list.dart';
import 'vector/vector_operations/float32_vector_unique.dart';
import 'vector/vector_operations/float32_vectors_multiplication.dart';
import 'vector/vector_operations/float32_vectors_add.dart';

void main() {
  VectorInitializationBenchmark.main();
  VectorUniqueBenchmark.main();
  VectorMulBenchmark.main();
  VectorAdditionBenchmark.main();
}
