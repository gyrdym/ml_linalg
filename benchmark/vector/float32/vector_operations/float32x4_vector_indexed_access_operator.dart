// Approx. 0.5 microsecond (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 1.0 microsecond (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 10000000;

class Float32x4VectorRandomAccessBenchmark extends BenchmarkBase {
  Float32x4VectorRandomAccessBenchmark()
      : super('Vector `[]` operator; $amountOfElements elements');

  late Vector vector;

  static void main() {
    Float32x4VectorRandomAccessBenchmark().report();
  }

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
      amountOfElements,
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
