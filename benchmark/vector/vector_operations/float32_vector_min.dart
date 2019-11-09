// Approx. 0.4 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorMinValueBenchmark extends BenchmarkBase {
  VectorMinValueBenchmark()
      : super('Vector min value, $amountOfElements elements');

  Float32x4Vector vector;

  static void main() {
    VectorMinValueBenchmark().report();
  }

  @override
  void run() {
    vector.min();
  }

  @override
  void setup() {
    vector = Float32x4Vector.randomFilled(amountOfElements, 1,
        min: -1000, max: 1000);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorMinValueBenchmark.main();
}
