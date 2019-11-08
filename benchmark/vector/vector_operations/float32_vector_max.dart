// Approx. 0.2 microsecond (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorMaxValueBenchmark extends BenchmarkBase {
  VectorMaxValueBenchmark()
      : super('Vector max value, $amountOfElements elements');

  Float32x4Vector vector;

  static void main() {
    VectorMaxValueBenchmark().report();
  }

  @override
  void run() {
    vector.max();
  }

  @override
  void setup() {
    vector = Float32x4Vector.randomFilled(amountOfElements, 1);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorMaxValueBenchmark.main();
}
