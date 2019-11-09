// Approx. 1.3 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorNormBenchmark extends BenchmarkBase {
  VectorNormBenchmark()
      : super('Vector norm, $amountOfElements elements');

  Vector vector;

  static void main() {
    VectorNormBenchmark().report();
  }

  @override
  void run() {
    vector.norm();
  }

  @override
  void setup() {
    vector = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
  }
}

void main() {
  VectorNormBenchmark.main();
}
