// Performance test of vector (10 000 000 elements in vector) initializing via `from`-constructor
// It takes approximately 5.5 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorInitializationBenchmark extends BenchmarkBase {
  const VectorInitializationBenchmark()
      : super('Vector initialization (from simple iterable), '
      '$amountOfElements elements');

  static void main() {
    const VectorInitializationBenchmark().report();
  }

  @override
  void run() {
    Float32x4Vector.fromList(List<double>.filled(amountOfElements, 1.0));
  }
}

void main() {
  VectorInitializationBenchmark.main();
}
