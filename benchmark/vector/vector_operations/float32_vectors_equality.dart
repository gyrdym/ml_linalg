// Approx. 0.35 microsecond (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';

const amountOfElements = 10000000;

class VectorsEqualityBenchmark extends BenchmarkBase {
  VectorsEqualityBenchmark()
      : super('Vectors equality, $amountOfElements elements');

  Float32Vector vector1;
  Float32Vector vector2;

  static void main() {
    VectorsEqualityBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 == vector2;
  }

  @override
  void setup() {
    vector1 = Float32Vector.randomFilled(amountOfElements);
    vector2 = Float32Vector.randomFilled(amountOfElements);
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  VectorsEqualityBenchmark.main();
}
