import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';

class Float64MatrixInverseLUBenchmark extends BenchmarkBase {
  Float64MatrixInverseLUBenchmark()
      : super('Matrix float64 inverse method (LU)');

  final Matrix _source = Matrix.randomSPD(300, dtype: DType.float64);

  static void main() {
    Float64MatrixInverseLUBenchmark().report();
  }

  @override
  void run() {
    _source.inverse(Inverse.LU);
  }
}

void main() {
  Float64MatrixInverseLUBenchmark.main();
}
