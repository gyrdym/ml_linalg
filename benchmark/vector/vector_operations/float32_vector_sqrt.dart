// Approx. 3.6 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';

const amountOfElements = 10000000;

class VectorSqrtBenchmark extends BenchmarkBase {
  VectorSqrtBenchmark()
      : super('Vector sqrt method, $amountOfElements elements');

  Float32Vector vector;

  static void main() {
    VectorSqrtBenchmark().report();
  }

  @override
  void run() {
    vector.sqrt();
  }

  @override
  void setup() {
    vector = Float32Vector.randomFilled(amountOfElements, min: 0, max: 200);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorSqrtBenchmark.main();
}
