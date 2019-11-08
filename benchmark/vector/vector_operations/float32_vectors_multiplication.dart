// Approx. 1.2 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorMulBenchmark extends BenchmarkBase {
  VectorMulBenchmark()
      : super('Vectors multiplication, $amountOfElements elements');

  Float32x4Vector vector1;
  Float32x4Vector vector2;

  static void main() {
    VectorMulBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 * vector2;
  }

  @override
  void setup() {
    vector1 = Float32x4Vector.randomFilled(amountOfElements, 1);
    vector2 = Float32x4Vector.randomFilled(amountOfElements, 1);
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorMulBenchmark.main();
}
