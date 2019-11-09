// Approx. 0.5 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorAbsBenchmark extends BenchmarkBase {
  VectorAbsBenchmark()
      : super('Vector abs, $amountOfElements elements');

  Vector vector;

  static void main() {
    VectorAbsBenchmark().report();
  }

  @override
  void run() {
    vector.abs(skipCaching: true);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorAbsBenchmark.main();
}
