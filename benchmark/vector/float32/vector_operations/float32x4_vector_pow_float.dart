// Approx. 1.5 second (MacBook Pro 2019), Dart version: 3.0.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorFloatPowBenchmark extends BenchmarkBase {
  Float32x4VectorFloatPowBenchmark()
      : super(
            'Vector `pow` method, floating-point power; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorFloatPowBenchmark().report();
  }

  @override
  void run() {
    vector.pow(1234);
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
  Float32x4VectorFloatPowBenchmark.main();
}
