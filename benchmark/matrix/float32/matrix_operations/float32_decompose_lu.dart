import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 300;
const numOfColumns = 300;

class Float32MatrixDecomposeLUBenchmark extends BenchmarkBase {
  Float32MatrixDecomposeLUBenchmark() : super('Matrix decompose method (LU)');

  final Matrix _source = Matrix.fromRows(
    List<Vector>.filled(
        numOfRows, Vector.randomFilled(numOfColumns, min: -1000, max: 1000)),
    dtype: DType.float32,
  );

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
