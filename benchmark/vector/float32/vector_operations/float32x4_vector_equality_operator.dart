// Approx. 0.3 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorEqualityOperatorBenchmark extends BenchmarkBase {
  Float32x4VectorEqualityOperatorBenchmark()
      : super('Vector `==` operator, operands: vector, vector; '
      '$amountOfElements elements');

  Vector vector1;
  Vector vector2;

  static void main() {
    Float32x4VectorEqualityOperatorBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector1 == vector2;
  }

  @override
  void setup() {
    vector1 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    vector2 = Vector.fromList(vector1.toList());
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}

void main() {
  Float32x4VectorEqualityOperatorBenchmark.main();
}
