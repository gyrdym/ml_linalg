// Approx. 0.6 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorAndVectorAdditionBenchmark extends BenchmarkBase {
  Float32x4VectorAndVectorAdditionBenchmark()
      : super('Vector `+` operator, operands: vector, vector; '
      '$amountOfElements elements');

  late Vector vector1;
  late Vector vector2;
  late Vector vector3;

  static void main() {
    Float32x4VectorAndVectorAdditionBenchmark().report();
  }

  @override
  void run() {
    vector3 = vector1 + vector2;
  }

  @override
  void setup() {
    vector1 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    vector2 = Vector.randomFilled(amountOfElements,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorAndVectorAdditionBenchmark.main();
}
