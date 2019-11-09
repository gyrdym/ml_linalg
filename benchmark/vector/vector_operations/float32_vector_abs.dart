// Approx. 0.5 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorAbsBenchmark extends BenchmarkBase {
  VectorAbsBenchmark()
      : super('Vector abs, $amountOfElements elements');

  Float32x4Vector vector;

  static void main() {
    VectorAbsBenchmark().report();
  }

  @override
  void run() {
    vector.abs();
  }

  @override
  void setup() {
    vector = Float32x4Vector.randomFilled(amountOfElements, 1,
        min: -1000, max: 2000, disableCache: true);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorAbsBenchmark.main();
}
