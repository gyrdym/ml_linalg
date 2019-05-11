// Approx. 0.16 microsecond (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';

const amountOfElements = 10000000;

class VectorMaxValueBenchmark extends BenchmarkBase {
  VectorMaxValueBenchmark()
      : super('Vector max value, $amountOfElements elements');

  Float32Vector vector;

  static void main() {
    VectorMaxValueBenchmark().report();
  }

  @override
  void run() {
    vector.max();
  }

  @override
  void setup() {
    vector = Float32Vector.randomFilled(amountOfElements);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorMaxValueBenchmark.main();
}
