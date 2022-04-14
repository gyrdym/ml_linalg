// Approx. 2.7 seconds (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorHammingDistanceBenchmark extends BenchmarkBase {
  Float32x4VectorHammingDistanceBenchmark()
      : super('Vector hamming distance; $amountOfElements elements');

  late Vector vector1;
  late Vector vector2;

  static void main() {
    Float32x4VectorHammingDistanceBenchmark().report();
  }

  @override
  void run() {
    vector1.distanceTo(vector2, distance: Distance.hamming);
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
      seed: 2,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorHammingDistanceBenchmark.main();
}
