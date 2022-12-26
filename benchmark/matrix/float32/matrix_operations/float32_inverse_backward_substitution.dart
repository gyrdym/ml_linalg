// Approx. 1.1 seconds (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 3.0 seconds (MacBook Air mid 2017), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';

class Float32MatrixInverseBackwardSubstitutionBenchmark extends BenchmarkBase {
  Float32MatrixInverseBackwardSubstitutionBenchmark()
      : super('Matrix float32 inverse method (Backward substitution)');

  final Matrix source = Matrix.randomSPD(500, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixInverseBackwardSubstitutionBenchmark().report();
  }

  @override
  void run() {
    source.inverse(Inverse.backwardSubstitution);
  }
}

void main() {
  Float32MatrixInverseBackwardSubstitutionBenchmark.main();
}
