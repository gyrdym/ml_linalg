// Performance test of vector (10 000 000 elements in vector) multiplication operation
// It takes approximately 2.7 second

import 'dart:math' as math;

import 'package:simd_vector/vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 10000000;

Float32x4Vector vector1;
Float32x4Vector vector2;

class VectorMultBenchmark extends BenchmarkBase {
  const VectorMultBenchmark() : super('Vectors multiplication, $amountOfElements elements');

  static void main() {
    new VectorMultBenchmark().report();
  }

  void run() {
    vector1 * vector2;
  }

  void setup() {
    final generator = new math.Random(new DateTime.now().millisecondsSinceEpoch);
    vector1 = new Float32x4Vector.from(new List<double>.generate(amountOfElements, (int idx) => generator.nextDouble()));
    vector2 = new Float32x4Vector.from(new List<double>.generate(amountOfElements, (int idx) => generator.nextDouble()));
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorMultBenchmark.main();
}