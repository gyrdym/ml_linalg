// Approx. 0.5 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorAbsBenchmark extends BenchmarkBase {
  Float32x4VectorAbsBenchmark()
      : super('Vector `abs` method; $amountOfElements elements');

  Vector? vector;

  static void main() {
    Float32x4VectorAbsBenchmark().report();
  }

  @override
  void run() {
    vector!.abs(skipCaching: true);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  Float32x4VectorAbsBenchmark.main();
}
