// Approx. 0.15 second (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 0.30 second (MacBook Air 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 100000;

class Float32x4VectorUniqueBenchmark extends BenchmarkBase {
  Float32x4VectorUniqueBenchmark()
      : super('Vector `unique` method; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorUniqueBenchmark().report();
  }

  @override
  void run() {
    vector.unique(skipCaching: true);
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
  Float32x4VectorUniqueBenchmark.main();
}
