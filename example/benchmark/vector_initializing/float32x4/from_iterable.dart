// Performance test of vector (10 000 000 elements in vector) initializing via `from`-constructor
// It takes approximately 4.3 second

import 'package:simd_vector/vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 10000000;

Float32x4Vector vector;

class VectorInitializationBenchmark extends BenchmarkBase {
  const VectorInitializationBenchmark() : super('Vector initialization (from simple iterable), $amountOfElements elements');

  static void main() {
    new VectorInitializationBenchmark().report();
  }

  void run() {
    vector = new Float32x4Vector.from(new List<double>.filled(amountOfElements, 1.0));
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorInitializationBenchmark.main();
}
