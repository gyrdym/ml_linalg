// Approx. 4.7 sec (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorFromListBenchmark extends BenchmarkBase {
  VectorFromListBenchmark()
      : super('Vector initialization (fromList), '
      '$amountOfElements elements');

  final _source = Vector
      .randomFilled(amountOfElements, min: -10000, max: 10000)
      .toList();

  static void main() {
    VectorFromListBenchmark().report();
  }

  @override
  void run() {
    Float32x4Vector.fromList(_source);
  }
}

void main() {
  VectorFromListBenchmark.main();
}
