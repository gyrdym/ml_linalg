// Approx. 0.4 sec (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorAndScalarDivisionBenchmark extends BenchmarkBase {
  Float32x4VectorAndScalarDivisionBenchmark()
      : super('Vector `/` operator, operands: vector, scalar; '
            '$amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorAndScalarDivisionBenchmark().report();
  }

  @override
  void run() {
    // ignore: unnecessary_statements
    vector / 13202461;
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
  Float32x4VectorAndScalarDivisionBenchmark.main();
}
