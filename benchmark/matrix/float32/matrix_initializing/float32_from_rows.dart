// Approx. 3 seconds (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixFromRowsBenchmark extends BenchmarkBase {
  Float32x4MatrixFromRowsBenchmark() :
        super('Matrix initialization, from rows');

  final _source =
    List<Vector>.filled(numOfColumns,
        Vector.randomFilled(numOfRows, min: -10000, max: 10000));

  static void main() {
    Float32x4MatrixFromRowsBenchmark().report();
  }

  @override
  void run() {
    Float32Matrix.rows(_source);
  }
}

void main() {
  Float32x4MatrixFromRowsBenchmark.main();
}
