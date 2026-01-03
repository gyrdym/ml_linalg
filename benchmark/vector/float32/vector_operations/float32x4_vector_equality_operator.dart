// Approx. 0.1 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorEqualityOperatorBenchmark extends BenchmarkBase {
  Float32x4VectorEqualityOperatorBenchmark()
      : super('Vector `==` operator, operands: vector, vector; '
            '$amountOfElements elements');

  late Vector vector1;
  late Vector vector2;

  static void main() {
    Float32x4VectorEqualityOperatorBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 == vector2;
  }

  @override
  void setup() {
    vector1 = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    vector2 = Vector.fromList(vector1.toList());
  }
}

void main() {
  Float32x4VectorEqualityOperatorBenchmark.main();
}
