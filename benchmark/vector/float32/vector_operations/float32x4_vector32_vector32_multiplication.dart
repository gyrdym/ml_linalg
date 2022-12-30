// Approx. 0.3 second (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 0.5 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorAndVectorMultiplicationBenchmark extends BenchmarkBase {
  Float32x4VectorAndVectorMultiplicationBenchmark()
      : super('Vector `*` operator, operands: vector32, vector32; '
            '$amountOfElements elements');

  late Vector vector1;
  late Vector vector2;

  static void main() {
    Float32x4VectorAndVectorMultiplicationBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 * vector2;
  }

  @override
  void setup() {
    vector1 = Vector.randomFilled(
      amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    vector2 = Vector.randomFilled(
      amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorAndVectorMultiplicationBenchmark.main();
}
