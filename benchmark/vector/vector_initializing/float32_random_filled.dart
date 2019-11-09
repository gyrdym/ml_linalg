// Approx. 5 sec (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorRandomFilledBenchmark extends BenchmarkBase {
  const VectorRandomFilledBenchmark()
      : super('Vector initialization (random filled), '
      '$amountOfElements elements');

  static void main() {
    const VectorRandomFilledBenchmark().report();
  }

  @override
  void run() {
    Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
  }
}

void main() {
  VectorRandomFilledBenchmark.main();
}
