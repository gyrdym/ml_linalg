// Approx. 3.0 seconds (MacBook Air mid 2017), Dart version: 2.16.0
// Approx. 2.2 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 20000;
const numOfColumns = 2000;

class Float32MatrixMultMatrixVectorBenchmark extends BenchmarkBase {
  Float32MatrixMultMatrixVectorBenchmark()
      : super('Matrix float32, matrix and vector multiplication ');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  final Vector _vector =
      Vector.randomFilled(numOfColumns, dtype: DType.float32, seed: 11);

  static void main() {
    Float32MatrixMultMatrixVectorBenchmark().report();
  }

  @override
  void run() {
    _source * _vector;
  }
}

void main() {
  Float32MatrixMultMatrixVectorBenchmark.main();
}
