// Approx. 2.0 seconds (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 3.2 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4Vector32AndVector64DivisionBenchmark extends BenchmarkBase {
  Float32x4Vector32AndVector64DivisionBenchmark()
      : super('Vector `/` operator, operands: vector float32, vector float64; '
            '$amountOfElements elements');

  late Vector vector32;
  late Vector vector64;
  late Vector result;

  static void main() {
    Float32x4Vector32AndVector64DivisionBenchmark().report();
  }

  @override
  void run() {
    result = vector32 / vector64;
  }

  @override
  void setup() {
    vector32 = Vector.randomFilled(
      amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    vector64 = Vector.randomFilled(
      amountOfElements,
      seed: 2,
      min: -1000,
      max: 1000,
      dtype: DType.float64,
    );
  }
}

void main() {
  Float32x4Vector32AndVector64DivisionBenchmark.main();
}
