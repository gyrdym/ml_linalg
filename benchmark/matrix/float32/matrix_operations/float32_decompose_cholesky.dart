import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 300;
const numOfColumns = 300;

class Float32MatrixDecomposeCholeskyBenchmark extends BenchmarkBase {
  Float32MatrixDecomposeCholeskyBenchmark()
      : super('Matrix decompose method (Cholesky)');

  final Matrix _source = Matrix.fromRows(
    List<Vector>.filled(
        numOfRows, Vector.randomFilled(numOfColumns, min: -1000, max: 1000)),
    dtype: DType.float32,
  );

  static void main() {
    Float32MatrixDecomposeCholeskyBenchmark().report();
  }

  @override
  void run() {
    _source.decompose(Decomposition.cholesky);
  }
}

void main() {
  Float32MatrixDecomposeCholeskyBenchmark.main();
}
