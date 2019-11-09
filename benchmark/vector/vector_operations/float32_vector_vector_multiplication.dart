// Approx. 0.6 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorMulBenchmark extends BenchmarkBase {
  VectorMulBenchmark()
      : super('Vectors multiplication, $amountOfElements elements');

  Vector vector1;
  Vector vector2;

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
    vector1 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
    vector2 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
  }
}

void main() {
  VectorMulBenchmark.main();
}
