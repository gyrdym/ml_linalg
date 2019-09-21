// Approx. 4.1 sec (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';

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
    Float32Vector.randomFilled(amountOfElements, min: -10000, max: 10000);
  }
}

void main() {
  VectorRandomFilledBenchmark.main();
}
