// Approx. 2 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorFilledBenchmark extends BenchmarkBase {
  Float32x4VectorFilledBenchmark()
      : super('Vector initialization (filled), '
            '$amountOfElements elements');

  static void main() {
    Float32x4VectorFilledBenchmark().report();
  }

  @override
  void run() {
    Vector.filled(amountOfElements.toInt(), 10000);
  }
}

void main() {
  Float32x4VectorFilledBenchmark.main();
}
