// Performance test of vector (10 000 000 elements in vector) multiplication operation
// It takes approximately 1.3 second (MacBook Air mid 2017)

import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';

const amountOfElements = 10000000;

Float32x4VectorInternal vector1;
Float32x4VectorInternal vector2;

class VectorMulBenchmark extends BenchmarkBase {
  const VectorMulBenchmark() : super('Vectors multiplication, $amountOfElements elements');

  static void main() {
    const VectorMulBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 * vector2;
  }

  @override
  void setup() {
    final generator = math.Random(DateTime.now().millisecondsSinceEpoch);
    vector1 = Float32x4VectorInternal.from(List<double>.generate(amountOfElements, (int idx) => generator.nextDouble()));
    vector2 = Float32x4VectorInternal.from(List<double>.generate(amountOfElements, (int idx) => generator.nextDouble()));
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorMulBenchmark.main();
}