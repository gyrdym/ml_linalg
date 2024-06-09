// Approx. 1.9 seconds (MacBook Pro 2019), Dart version: 3.2.4

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorExpBenchmark {
  static void main() {
    final vector = Vector.randomFilled(
      amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );

    final start = DateTime.now();

    vector.exp();

    final time = DateTime.now().difference(start).inMicroseconds;

    print(
        'Vector `exp` method; $amountOfElements elements (RunTime): $time us');
  }
}

void main() {
  Float32x4VectorExpBenchmark.main();
}
