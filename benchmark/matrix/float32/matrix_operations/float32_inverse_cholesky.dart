import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixInverseCholeskyBenchmark extends BenchmarkBase {
  Float32MatrixInverseCholeskyBenchmark()
      : super('Matrix float32 inverse method (Cholesky)');

  final Matrix _source = Matrix.randomSPD(300, dtype: DType.float32);

  static void main() {
    Float32MatrixInverseCholeskyBenchmark().report();
  }

  @override
  void run() {
    _source.inverse(Inverse.cholesky);
  }
}

void main() {
  Float32MatrixInverseCholeskyBenchmark.main();
}
