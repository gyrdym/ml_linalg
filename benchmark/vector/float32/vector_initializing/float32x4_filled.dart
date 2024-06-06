// Approx. 0.3 second (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorFilledBenchmark extends BenchmarkBase {
  Float32x4VectorFilledBenchmark()
      : super('Vector initialization (filled), '
            '$amountOfElements elements');

  static void main() {
    Float32x4VectorFilledBenchmark().report();
  }

  @override
  void run() {
    Vector.filled(amountOfElements, 10000);
  }
}

void main() {
  Float32x4VectorFilledBenchmark.main();
}
