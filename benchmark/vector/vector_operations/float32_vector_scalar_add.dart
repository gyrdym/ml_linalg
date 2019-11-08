// Approx. 0.5 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorAndScalarAdditionBenchmark extends BenchmarkBase {
  VectorAndScalarAdditionBenchmark()
      : super('Vector and scalar addition, $amountOfElements elements');

  Float32x4Vector vector;

  static void main() {
    VectorAndScalarAdditionBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector + 1246;
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
  VectorAndScalarAdditionBenchmark.main();
}
