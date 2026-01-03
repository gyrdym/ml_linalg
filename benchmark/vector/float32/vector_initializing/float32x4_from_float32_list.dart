// Approx. 3 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorFromFloatListBenchmark extends BenchmarkBase {
  Float32x4VectorFromFloatListBenchmark()
      : super('Vector initialization (fromList, List Type - Float32List), '
            '$amountOfElements elements');

  final _source = Float32List.fromList(Vector.randomFilled(
    amountOfElements.toInt(),
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
