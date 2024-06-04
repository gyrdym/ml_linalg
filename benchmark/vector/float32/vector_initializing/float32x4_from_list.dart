// Approx. 0.62 second (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 3.7 second (MacBook Air mid 2017), Dart VM version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorFromListBenchmark extends BenchmarkBase {
  Float32x4VectorFromListBenchmark()
      : super('Vector initialization (fromList), '
            '$amountOfElements elements');

  final _source = Vector.randomFilled(
    amountOfElements,
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
