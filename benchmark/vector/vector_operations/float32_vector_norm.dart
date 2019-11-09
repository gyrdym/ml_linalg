// Approx. 1.3 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorNormBenchmark extends BenchmarkBase {
  VectorNormBenchmark()
      : super('Vector norm, $amountOfElements elements');

  Float32x4Vector vector;

  static void main() {
    VectorNormBenchmark().report();
  }

  @override
  void run() {
    vector.norm();
  }

  @override
  void setup() {
    vector = Float32x4Vector.randomFilled(amountOfElements, 1,
        min: -200, max: 200);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorNormBenchmark.main();
}
