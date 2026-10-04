// Approx. 0.1 seconds (MacBook Pro 2019), Dart version: 3.12.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const _amountOfElements = 1e8;

class Float32x4VectorInPlaceDivisionBenchmark extends BenchmarkBase {
  Float32x4VectorInPlaceDivisionBenchmark()
      : super('VectorBuffer.divide, operands: vector32, ones vector32; '
            '$_amountOfElements elements');

  late VectorBuffer vector;
  late Vector onesVector;

  static void main() {
    Float32x4VectorInPlaceDivisionBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    vector.divide(onesVector);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      _amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    ).toBuffer();
    onesVector =
        Vector.filled(_amountOfElements.toInt(), 1, dtype: DType.float32);
  }
}

void main() {
  Float32x4VectorInPlaceDivisionBenchmark.main();
}
