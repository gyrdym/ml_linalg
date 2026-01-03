// Approx. 6 seconds (MacBook Pro 2019), Dart version: 3.10.7
import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;
final generator = math.Random();
final index = generator.nextInt(amountOfElements.toInt() - 1);
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
      amountOfElements.toInt(),
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
