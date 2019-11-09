// Approx. 0.5 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorAndScalarAdditionBenchmark extends BenchmarkBase {
  VectorAndScalarAdditionBenchmark()
      : super('Vector and scalar addition, $amountOfElements elements');

  Vector vector;

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
    vector = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
    );
  }
}

void main() {
  VectorAndScalarAdditionBenchmark.main();
}
