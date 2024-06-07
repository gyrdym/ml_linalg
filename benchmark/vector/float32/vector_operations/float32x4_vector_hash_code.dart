// Approx. 2.5 seconds (MacBook Pro 2019), Dart version: 3.2.4

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorHashCodeBenchmark extends BenchmarkBase {
  Float32x4VectorHashCodeBenchmark()
      : super('Vector `hashCode`; $amountOfElements elements');

  List<num> source = Vector.randomFilled(
    amountOfElements,
    seed: 1,
    min: -1000,
    max: 1000,
    dtype: DType.float32,
  ).toList();

  static void main() {
    Float32x4VectorHashCodeBenchmark().report();
  }

  @override
  void run() {
    Vector.fromList(
      source,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorHashCodeBenchmark.main();
}
