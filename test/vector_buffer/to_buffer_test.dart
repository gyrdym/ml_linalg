import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    test('should return a separate mutable interface sharing vector data', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0], dtype: dtype);
      final buffer = vector.toBuffer();

      expect(buffer, isA<VectorBuffer>());
      expect(buffer, isNot(isA<Vector>()));

      buffer.add(Vector.fromList([2.0, 3.0, 4.0], dtype: dtype));

      expect(vector, equals([3.0, 5.0, 7.0]));
    });
  }
}
