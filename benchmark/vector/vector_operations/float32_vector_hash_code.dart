// approx. 0.4 seconds (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorHashCodeBenchmark extends BenchmarkBase {
  VectorHashCodeBenchmark()
      : super('Vector hash code, $amountOfElements elements');

  Vector vector;

  static void main() {
    VectorHashCodeBenchmark().report();
  }

  @override
  void run() {
    vector.hashCode;
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
  VectorHashCodeBenchmark.main();
}
