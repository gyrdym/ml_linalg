// Approx. 1.9 seconds (MacBook Pro 2019), Dart version: 2.16.0
// creation + hash code calculation: approx. 2.9 seconds (MacBook Air mid 2017) Dart 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorHashCodeBenchmark extends BenchmarkBase {
  Float32x4VectorHashCodeBenchmark()
      : super('Vector `hashCode`; $amountOfElements elements');

  Vector? vector;

  static void main() {
    Float32x4VectorHashCodeBenchmark().report();
  }

  @override
  void run() {
    Vector.randomFilled(
      amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    ).hashCode;
  }
}

void main() {
  Float32x4VectorHashCodeBenchmark.main();
}
