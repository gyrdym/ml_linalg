// Approx. 3 sec (MacBook Air mid 2017)

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
    Float32Vector.randomFilled(amountOfElements);
  }
}

void main() {
  VectorRandomFilledBenchmark.main();
}
