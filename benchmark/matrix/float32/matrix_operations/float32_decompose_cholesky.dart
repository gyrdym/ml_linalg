import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixDecomposeCholeskyBenchmark extends BenchmarkBase {
  Float32MatrixDecomposeCholeskyBenchmark()
      : super('Matrix decompose method (Cholesky)');

  final Matrix _source = Matrix.randomSPD(300, dtype: DType.float32);

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
