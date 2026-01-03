// Approx. 1.0 sec (MacBook Pro 2019), Dart version: 3.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorAndListMultiplicationBenchmark extends BenchmarkBase {
  Float32x4VectorAndListMultiplicationBenchmark()
      : super('Vector `*` operator, operands: vector, list; '
            '$amountOfElements elements');

  late Vector vector;
  late List<num> list;
  late Vector result;

  static void main() {
    Float32x4VectorAndListMultiplicationBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    result = vector * list;
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    list = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 2,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    ).toList();
  }
}

void main() {
  Float32x4VectorAndListMultiplicationBenchmark.main();
}
