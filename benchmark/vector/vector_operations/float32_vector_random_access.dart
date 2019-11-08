// Approx. 1 microsecond (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';

const amountOfElements = 10000000;

class VectorRandomAccessBenchmark extends BenchmarkBase {
  VectorRandomAccessBenchmark()
      : super('Vector random access, $amountOfElements elements');

  Float32x4Vector vector;

  static void main() {
    VectorRandomAccessBenchmark().report();
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
    vector = Float32x4Vector.filled(amountOfElements, 10);
  }

  void tearDown() {
    vector = null;
  }
}

void main() {
  VectorRandomAccessBenchmark.main();
}
