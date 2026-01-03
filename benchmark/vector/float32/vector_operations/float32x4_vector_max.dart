// Approx. 1.8 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorMaxValueBenchmark extends BenchmarkBase {
  Float32x4VectorMaxValueBenchmark()
      : super('Vector `max` method; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorMaxValueBenchmark().report();
  }

  @override
  void run() {
    vector.max(skipCaching: true);
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
  Float32x4VectorMaxValueBenchmark.main();
}
