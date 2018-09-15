// Performance test of vector (10 000 000 elements in vector) initializing via `from`-constructor
// It takes approximately 6.3 second

import 'package:linalg/vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 10000000;

Float64x2Vector vector;

class VectorInitializationBenchmark extends BenchmarkBase {
  const VectorInitializationBenchmark() : super('Vector initialization (from simple iterable), $amountOfElements elements');

  static void main() {
    new VectorInitializationBenchmark().report();
  }

  void run() {
    vector = new Float64x2Vector.from(new List<double>.filled(amountOfElements, 1.0));
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorInitializationBenchmark.main();
}
