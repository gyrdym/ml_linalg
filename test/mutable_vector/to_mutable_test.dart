import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    final values = [10.0, 20.0, 30.0, 40.0, 50.0];
    final otherValues = [1.0, 2.0, 3.0, 4.0, 5.0];

    test('should return a mutable copy with independent storage', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0], dtype: dtype);
      final mutable = vector.toMutable();

      expect(mutable, isA<MutableVector>());
      expect(mutable, isNot(isA<Vector>()));

      mutable.add(Vector.fromList([2.0, 3.0, 4.0], dtype: dtype));

      expect(mutable.toVector(), equals([3.0, 5.0, 7.0]));
      expect(vector, equals([1.0, 2.0, 3.0]));

      expect(mutable[0], 3.0);
      expect(mutable.toList(), equals([3.0, 5.0, 7.0]));
    });

    test('should leave the original vector unchanged after addition', () {
      final vector = Vector.fromList(values, dtype: dtype);
      final mutable = vector.toMutable();

      expect(vector.sum(), 150.0);

      mutable.add(Vector.fromList(otherValues, dtype: dtype));

      expect(mutable.toVector(), equals([11.0, 22.0, 33.0, 44.0, 55.0]));
      expect(vector, equals(values));
      expect(vector.sum(), 150.0);
    });

    test('should leave the original vector unchanged after subtraction', () {
      final vector = Vector.fromList(values, dtype: dtype);
      final mutable = vector.toMutable();

      expect(vector.sum(), 150.0);

      mutable.subtract(Vector.fromList(otherValues, dtype: dtype));

      expect(mutable.toVector(), equals([9.0, 18.0, 27.0, 36.0, 45.0]));
      expect(vector, equals(values));
      expect(vector.sum(), 150.0);
    });

    test('should leave the original vector unchanged after multiplication', () {
      final vector = Vector.fromList(values, dtype: dtype);
      final mutable = vector.toMutable();

      expect(vector.sum(), 150.0);

      mutable.multiply(Vector.fromList(otherValues, dtype: dtype));

      expect(mutable.toVector(), equals([10.0, 40.0, 90.0, 160.0, 250.0]));
      expect(vector, equals(values));
      expect(vector.sum(), 150.0);
    });

    test('should leave the original vector unchanged after division', () {
      final vector = Vector.fromList(values, dtype: dtype);
      final mutable = vector.toMutable();

      expect(vector.sum(), 150.0);

      mutable.divide(Vector.fromList(otherValues, dtype: dtype));

      expect(mutable.toVector(), equals([10.0, 10.0, 10.0, 10.0, 10.0]));
      expect(vector, equals(values));
      expect(vector.sum(), 150.0);
    });
  }
}
