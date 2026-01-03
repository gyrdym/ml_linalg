// Approx. 0.15 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e5;

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
      amountOfElements.toInt(),
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
