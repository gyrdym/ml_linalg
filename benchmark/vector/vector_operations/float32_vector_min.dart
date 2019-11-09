// Approx. 0.4 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorMinValueBenchmark extends BenchmarkBase {
  VectorMinValueBenchmark()
      : super('Vector min value, $amountOfElements elements');

  Vector vector;

  static void main() {
    VectorMinValueBenchmark().report();
  }

  @override
  void run() {
    vector.min();
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
  VectorMinValueBenchmark.main();
}
