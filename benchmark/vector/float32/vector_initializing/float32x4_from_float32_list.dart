// Approx. 0.4 sec (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 0.5 sec (MacBook Air mid 2017), Dart VM version: 2.16.0

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorFromFloatListBenchmark extends BenchmarkBase {
  Float32x4VectorFromFloatListBenchmark()
      : super('Vector initialization (fromList, List Type - Float32List), '
            '$amountOfElements elements');

  final _source = Float32List.fromList(Vector.randomFilled(
    amountOfElements,
    seed: 1,
    min: -1000,
    max: 1000,
  ).toList());

  static void main() {
    Float32x4VectorFromFloatListBenchmark().report();
  }

  @override
  void run() {
    Vector.fromList(_source);
  }
}

void main() {
  Float32x4VectorFromFloatListBenchmark.main();
}
