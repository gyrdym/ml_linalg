import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 100000;
const numOfColumns = 10000;

class Float32MatrixMultMatrixVectorBenchmark extends BenchmarkBase {
  Float32MatrixMultMatrixVectorBenchmark()
      : super('Matrix float32, matrix and vector multiplication ');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32);

  final Vector _vector =
      Vector.randomFilled(numOfColumns, dtype: DType.float32);

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
