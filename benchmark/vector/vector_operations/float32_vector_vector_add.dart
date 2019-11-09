// Approx. 0.6 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorAdditionBenchmark extends BenchmarkBase {
  VectorAdditionBenchmark()
      : super('Vectors addition, $amountOfElements elements');

  Vector vector1;
  Vector vector2;

  static void main() {
    VectorAdditionBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 + vector2;
  }

  @override
  void setup() {
    vector1 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
    vector2 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
  }
}

void main() {
  VectorAdditionBenchmark.main();
}
