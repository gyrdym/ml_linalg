// Approx. 3 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';

const amountOfElements = 10000000;

class VectorFromListBenchmark extends BenchmarkBase {
  const VectorFromListBenchmark()
      : super('Vector initialization (fromList), '
      '$amountOfElements elements');

  static void main() {
    const VectorFromListBenchmark().report();
  }

  @override
  void run() {
    Float32Vector.fromList(List<double>.filled(amountOfElements, 1.0));
  }
}

void main() {
  VectorFromListBenchmark.main();
}
