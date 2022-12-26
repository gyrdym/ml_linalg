// Approx. 35 second (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 50 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorMedianBenchmark extends BenchmarkBase {
  Float32x4VectorMedianBenchmark()
      : super('Vector `median` method; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorMedianBenchmark().report();
  }

  @override
  void run() {
    vector.median(skipCaching: true);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorMedianBenchmark.main();
}
