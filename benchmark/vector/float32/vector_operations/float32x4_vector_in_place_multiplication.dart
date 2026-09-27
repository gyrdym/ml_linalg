// Approx. 0.29 seconds (MacBook Pro 2019), Dart version: 3.12.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const _amountOfElements = 1e8;

class Float32x4VectorInPlaceMultiplicationBenchmark extends BenchmarkBase {
  Float32x4VectorInPlaceMultiplicationBenchmark()
      : super('Vector multiplyInPlace, operands: vector32, ones vector32; '
            '$_amountOfElements elements');

  late Vector vector;
  late Vector onesVector;

  static void main() {
    Float32x4VectorInPlaceMultiplicationBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    vector.multiplyInPlace(onesVector);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      _amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    onesVector =
        Vector.filled(_amountOfElements.toInt(), 1, dtype: DType.float32);
  }
}

void main() {
  Float32x4VectorInPlaceMultiplicationBenchmark.main();
}
