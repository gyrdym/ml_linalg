// Performance test of vector (10 000 000 elements in vector) initializing via `from`-constructor

import 'package:dart_vector/vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

const int AMOUNT_OF_ELEMENTS = 10000000;

Float32x4Vector vector;

class VectorInitializationBenchmark extends BenchmarkBase {
  const VectorInitializationBenchmark() : super('Vector initialization, $AMOUNT_OF_ELEMENTS elements');

  static void main() {
    new VectorInitializationBenchmark().report();
  }

  void run() {
    vector = new Float32x4Vector.from(new List<double>.filled(AMOUNT_OF_ELEMENTS, 1.0));
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorInitializationBenchmark.main();
}
