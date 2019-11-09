// Approx. 0.3 second (MacBook Air 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 100000;

class VectorUniqueBenchmark extends BenchmarkBase {
  VectorUniqueBenchmark()
      : super('Vector unnique elements obtaining, $amountOfElements elements');

  Vector vector;

  static void main() {
    VectorUniqueBenchmark().report();
  }

  @override
  void run() {
    vector.unique(skipCaching: true);
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
  VectorUniqueBenchmark.main();
}
