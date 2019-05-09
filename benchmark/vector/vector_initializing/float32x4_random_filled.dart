// Approx. 1.6 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';

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
    Float32x4Vector.randomFilled(amountOfElements);
  }
}

void main() {
  VectorRandomFilledBenchmark.main();
}
