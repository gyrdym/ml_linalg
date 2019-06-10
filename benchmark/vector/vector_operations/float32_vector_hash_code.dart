// Creation + hashing - approx. 11.5 seconds (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';

const amountOfElements = 10000000;

class VectorHashCodeBenchmark extends BenchmarkBase {
  VectorHashCodeBenchmark()
      : super('Vector hash code, $amountOfElements elements');

  static void main() {
    VectorHashCodeBenchmark().report();
  }

  @override
  void run() {
    Float32Vector.randomFilled(amountOfElements).hashCode;
  }
}

void main() {
  VectorHashCodeBenchmark.main();
}
