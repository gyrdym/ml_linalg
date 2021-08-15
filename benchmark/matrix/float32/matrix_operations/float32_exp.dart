// Approx. 12 second (MacBook Air mid 2017), Dart VM version: 2.7.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixExpBenchmark extends BenchmarkBase {
  Float32MatrixExpBenchmark() : super('Matrix exp method');

  final Matrix _source = Matrix.fromRows(
    List<Vector>.filled(
        numOfRows, Vector.randomFilled(numOfColumns, min: -1000, max: 1000)),
    dtype: DType.float32,
  );

  static void main() {
    Float32MatrixExpBenchmark().report();
  }

  @override
  void run() {
    _source.exp(skipCaching: true);
  }
}

void main() {
  Float32MatrixExpBenchmark.main();
}
