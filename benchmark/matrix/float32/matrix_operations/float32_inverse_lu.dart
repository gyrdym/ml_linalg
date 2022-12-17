// Approx. 7 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixInverseLUBenchmark extends BenchmarkBase {
  Float32MatrixInverseLUBenchmark()
      : super('Matrix float32 inverse method (LU)');

  final Matrix _source = Matrix.randomSPD(300, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixInverseLUBenchmark().report();
  }

  @override
  void run() {
    _source.inverse(Inverse.LU);
  }
}

void main() {
  Float32MatrixInverseLUBenchmark.main();
}
