// Approx. 0.5 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorAndScalarMultiplicationBenchmark extends BenchmarkBase {
  VectorAndScalarMultiplicationBenchmark()
      : super('Vector and scalar multiplication, $amountOfElements elements');

  Vector vector;

  static void main() {
    VectorAndScalarMultiplicationBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector * 120246;
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
  VectorAndScalarMultiplicationBenchmark.main();
}
