// Approx. 3 second (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixDecomposeCholeskyBenchmark extends BenchmarkBase {
  Float32MatrixDecomposeCholeskyBenchmark()
      : super('Matrix float32 decompose method (Cholesky)');

  final Matrix source = Matrix.randomSPD(1000, dtype: DType.float32, seed: 4);

  static void main() {
    Float32MatrixDecomposeCholeskyBenchmark().report();
  }

  @override
  void run() {
    source.decompose(Decomposition.cholesky);
  }
}

void main() {
  Float32MatrixDecomposeCholeskyBenchmark.main();
}
