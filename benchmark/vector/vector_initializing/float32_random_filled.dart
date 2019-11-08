// Approx. 3.5 sec (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

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
    Float32x4Vector.randomFilled(amountOfElements, 1, min: -10000, max: 10000);
  }
}

void main() {
  VectorRandomFilledBenchmark.main();
}
