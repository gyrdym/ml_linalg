// Approx. 2 seconds (MacBook Pro 2019), Dart version: 3.2.4

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4Vector32AndVector64MultiplicationBenchmark
    extends BenchmarkBase {
  Float32x4Vector32AndVector64MultiplicationBenchmark()
      : super('Vector `*` operator, operands: vector float32, vector float64; '
            '$amountOfElements elements');

  late Vector vector32;
  late Vector vector64;
  late Vector result;

  static void main() {
    Float32x4Vector32AndVector64MultiplicationBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    result = vector32 * vector64;
  }

  @override
  void setup() {
    vector32 = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    vector64 = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 2,
      min: -1000,
      max: 1000,
      dtype: DType.float64,
    );
  }
}

void main() {
  Float32x4Vector32AndVector64MultiplicationBenchmark.main();
}
