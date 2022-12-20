// Approx. 1.2 seconds (MacBook Air mid 2017), Dart VM version: 2.5.0
// Approx. 0.8 second (MacBook Pro mid 2019), Dart VM version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromRowsBenchmark extends BenchmarkBase {
  Float32MatrixFromRowsBenchmark() : super('Matrix initialization (fromRows)');

  final _source = List<Vector>.filled(numOfColumns,
      Vector.randomFilled(numOfRows, min: -10000, max: 10000, seed: 12));

  static void main() {
    Float32MatrixFromRowsBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromRows(_source, dtype: DType.float32);
  }
}

void main() {
  Float32MatrixFromRowsBenchmark.main();
}
