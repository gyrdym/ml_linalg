// Performance test of vector (10 000 000 elements in vector) addition operation
// It takes approximately 2.7 second

import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:simd_vector/vector.dart';

const amountOfElements = 10000000;

Float32x4Vector vector1;
Float32x4Vector vector2;

class VectorAdditionBenchmark extends BenchmarkBase {
  const VectorAdditionBenchmark() : super('Vectors addition, $amountOfElements elements');

  static void main() {
    new VectorAdditionBenchmark().report();
  }

  void run() {
    vector1 + vector2;
  }

  void setup() {
    vector1 = new Float32x4Vector.randomFilled(amountOfElements);
    vector2 = new Float32x4Vector.randomFilled(amountOfElements);
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorAdditionBenchmark.main();
}