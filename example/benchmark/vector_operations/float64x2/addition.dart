// Performance test of vector (10 000 000 elements in vector) addition operation
// It takes approximately 2.6 second (MacBook Air mid 2017)

import 'package:linalg/src/simd/float64x2_vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:linalg/src/simd/simd_vector.dart';

const int amountOfElements = 10000000;

SIMDVector vector1;
SIMDVector vector2;

class VectorAdditionBenchmark extends BenchmarkBase {
  const VectorAdditionBenchmark() : super('Vectors addition, $amountOfElements elements');

  static void main() {
    const VectorAdditionBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 + vector2;
  }

  @override
  void setup() {
    vector1 = Float64x2VectorFactory.from(List<double>.filled(amountOfElements, 1.0));
    vector2 = Float64x2VectorFactory.from(List<double>.filled(amountOfElements, 1.0));
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorAdditionBenchmark.main();
}