// Approx. 4.7 sec (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class VectorFromListBenchmark extends BenchmarkBase {
  VectorFromListBenchmark()
      : super('Vector initialization (fromList), '
      '$amountOfElements elements');

  final _source = Vector.randomFilled(amountOfElements,
    seed: 1,
    min: -1000,
    max: 1000,
  ).toList();

  static void main() {
    VectorFromListBenchmark().report();
  }

  @override
  void run() {
    Vector.fromList(_source);
  }
}

void main() {
  VectorFromListBenchmark.main();
}
