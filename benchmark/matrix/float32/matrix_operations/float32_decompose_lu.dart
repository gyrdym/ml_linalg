import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 300;
const numOfColumns = 300;

class Float32MatrixDecomposeLUBenchmark extends BenchmarkBase {
  Float32MatrixDecomposeLUBenchmark() : super('Matrix decompose method (LU)');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32);

  static void main() {
    Float32MatrixDecomposeLUBenchmark().report();
  }

  @override
  void run() {
    _source.decompose(Decomposition.LU);
  }
}

void main() {
  Float32MatrixDecomposeLUBenchmark.main();
}
