// Approx. 0.7 second (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 1.1 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorNormBenchmark extends BenchmarkBase {
  Float32x4VectorNormBenchmark()
      : super('Vector `norm` method; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorNormBenchmark().report();
  }

  @override
  void run() {
    vector.norm(Norm.euclidean, true);
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
  Float32x4VectorNormBenchmark.main();
}
