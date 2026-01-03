// Approx. 7 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorFromListBenchmark extends BenchmarkBase {
  Float32x4VectorFromListBenchmark()
      : super('Vector initialization (fromList), '
            '$amountOfElements elements');

  final _source = Vector.randomFilled(
    amountOfElements.toInt(),
    seed: 1,
    min: -1000,
    max: 1000,
  ).toList();

  static void main() {
    Float32x4VectorFromListBenchmark().report();
  }

  @override
  void run() {
    Vector.fromList(_source);
  }
}

void main() {
  Float32x4VectorFromListBenchmark.main();
}
