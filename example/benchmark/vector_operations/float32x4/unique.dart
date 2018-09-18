// Performance test of vector (10 000 elements in vector) multiplication operation
// It takes approximately 1 second

import 'dart:math' as math;

import 'package:linalg/src/simd/float32x4_vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:linalg/src/simd/simd_vector.dart';

const amountOfElements = 10000;

SIMDVector vector;

class VectorUniqueBenchmark extends BenchmarkBase {
  const VectorUniqueBenchmark() : super('Vector unnique elements obtaining, $amountOfElements elements');

  static void main() {
    const VectorUniqueBenchmark().report();
  }

  void run() {
    vector.unique();
  }

  void setup() {
    final generator = math.Random(DateTime.now().millisecondsSinceEpoch);
    vector = Float32x4VectorFactory.from(List<double>.generate(amountOfElements, (int idx) => generator.nextDouble()));
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorUniqueBenchmark.main();
}