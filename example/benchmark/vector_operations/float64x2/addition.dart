// Performance test of vector (10 000 000 elements in vector) addition operation
// It takes approximately 4.7 second

import 'package:simd_vector/vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

const int AMOUNT_OF_ELEMENTS = 10000000;

Float64x2Vector vector1;
Float64x2Vector vector2;

class VectorAdditionBenchmark extends BenchmarkBase {
  const VectorAdditionBenchmark() : super('Vectors addition, $AMOUNT_OF_ELEMENTS elements');

  static void main() {
    new VectorAdditionBenchmark().report();
  }

  void run() {
    vector1 + vector2;
  }

  void setup() {
    vector1 = new Float64x2Vector.from(new List<double>.filled(AMOUNT_OF_ELEMENTS, 1.0));
    vector2 = new Float64x2Vector.from(new List<double>.filled(AMOUNT_OF_ELEMENTS, 1.0));
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorAdditionBenchmark.main();
}