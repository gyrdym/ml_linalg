// Approx. 6.2 second (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixInverseCholeskyBenchmark extends BenchmarkBase {
  Float32MatrixInverseCholeskyBenchmark()
      : super('Matrix float32 inverse method (Cholesky)');

  final Matrix source = Matrix.randomSPD(300, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixInverseCholeskyBenchmark().report();
  }

  @override
  void run() {
    source.inverse(Inverse.cholesky);
  }
}

void main() {
  Float32MatrixInverseCholeskyBenchmark.main();
}
