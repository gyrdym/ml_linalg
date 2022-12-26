// Approx. 1.2 seconds (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 2.8 seconds (MacBook Air mid 2017), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixInverseForwardSubstitutionBenchmark extends BenchmarkBase {
  Float32MatrixInverseForwardSubstitutionBenchmark()
      : super('Matrix float32 inverse method (Forward substitution)');

  final Matrix source = Matrix.randomSPD(500, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixInverseForwardSubstitutionBenchmark().report();
  }

  @override
  void run() {
    source.inverse(Inverse.forwardSubstitution);
  }
}

void main() {
  Float32MatrixInverseForwardSubstitutionBenchmark.main();
}
