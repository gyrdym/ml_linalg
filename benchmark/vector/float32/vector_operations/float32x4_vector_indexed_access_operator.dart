// Approx. 0.05 microsecond (MacBook Pro 2019), Dart version: 3.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorRandomAccessBenchmark extends BenchmarkBase {
  Float32x4VectorRandomAccessBenchmark()
      : super('Vector `[]` operator; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorRandomAccessBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    // ignore: unnecessary_statements
    vector[100];
    // ignore: unnecessary_statements
    vector[1000];
    // ignore: unnecessary_statements
    vector[33333];
    // ignore: unnecessary_statements
    vector[7777777];
    // ignore: unnecessary_statements
    vector[8888888];
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
  }
}

void main() {
  Float32x4VectorRandomAccessBenchmark.main();
}
