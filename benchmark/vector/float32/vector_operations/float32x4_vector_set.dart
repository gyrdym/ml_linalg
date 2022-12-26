// Approx. 0.6 second (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 0.9 sec (MacBook Air mid 2017)
import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;
final generator = math.Random();
final index = generator.nextInt(amountOfElements - 1);
final value = generator.nextDouble();

class Float32x4VectorSetBenchmark extends BenchmarkBase {
  Float32x4VectorSetBenchmark() : super('Vector "set" method');

  late Vector vector;

  static void main() {
    Float32x4VectorSetBenchmark().report();
  }

  @override
  void run() {
    vector.set(index, value);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorSetBenchmark.main();
}
