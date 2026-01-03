// Approx. 0.3 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const amountOfElements = 1e8;

class Float32x4VectorAbsBenchmark {
  static void main() {
    final length = amountOfElements.toInt();
    final vector = Vector.randomFilled(
      length,
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );

    final start = DateTime.now();

    vector.abs();

    final time = DateTime.now().difference(start).inMicroseconds;

    print('Vector `abs` method; $length elements (RunTime): $time us');
  }
}

void main() {
  Float32x4VectorAbsBenchmark.main();
}
