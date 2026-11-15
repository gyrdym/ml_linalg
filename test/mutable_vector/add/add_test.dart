import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../dtype_to_title.dart';
import '../mutable_vector_test_helpers.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(dtypeToVectorTestTitle[dtype], () {
      test('should mutate the copy and return the same mutable vector', () {
        final vector = Vector.fromList([12.0, 20.0, 30.0], dtype: dtype);
        final other = Vector.fromList([3.0, 4.0, 5.0], dtype: dtype);
        final mutable = vector.toMutable();
        final result = mutable.add(other);

        expect(result, same(mutable));
        expect(mutable.toVector(), equals([15.0, 24.0, 35.0]));
        expect(vector, equals([12.0, 20.0, 30.0]));
      });

      test('should add vectors with 4 and 5 elements', () {
        final fourElementVector =
            Vector.fromList([12.0, 20.0, 30.0, 40.0], dtype: dtype);
        final fourElementOther =
            Vector.fromList([3.0, 4.0, 5.0, 6.0], dtype: dtype);
        final fiveElementVector =
            Vector.fromList([12.0, 20.0, 30.0, 40.0, 50.0], dtype: dtype);
        final fiveElementOther =
            Vector.fromList([3.0, 4.0, 5.0, 6.0, 7.0], dtype: dtype);

        final fourElementMutable = fourElementVector.toMutable()
          ..add(fourElementOther);
        final fiveElementMutable = fiveElementVector.toMutable()
          ..add(fiveElementOther);

        expect(fourElementMutable.toVector(), equals([15.0, 24.0, 35.0, 46.0]));
        expect(
          fiveElementMutable.toVector(),
          equals([15.0, 24.0, 35.0, 46.0, 57.0]),
        );
      });

      test('should add 5 elements with negative and fractional values', () {
        final vector =
            Vector.fromList([-2.5, 1.5, -4.0, 6.25, -8.5], dtype: dtype);
        final other =
            Vector.fromList([1.25, -2.5, 0.5, -1.25, 3.5], dtype: dtype);

        final mutable = vector.toMutable()..add(other);

        expect(mutable.toVector(), equals([-1.25, -1.0, -3.5, 5.0, -5.0]));
      });

      test('should calculate the correct sum after addition', () {
        final vector = Vector.fromList([1, 2, 3, 4, 5], dtype: dtype);
        final other = vectorWithPaddedTail(
          [10, 20, 30, 40, 50],
          dtype: dtype,
          paddingValue: 123,
        );

        final mutable = vector.toMutable()..add(other);

        expect(mutable.toVector().sum(), 165);
      });

      test('should support a vector of a different dtype', () {
        final vector = Vector.fromList([8.0, 18.0], dtype: dtype);
        final other = Vector.fromList(
          [2.0, 3.0],
          dtype: dtype == DType.float32 ? DType.float64 : DType.float32,
        );

        final mutable = vector.toMutable()..add(other);

        expect(mutable.toVector(), equals([10.0, 21.0]));
      });

      test('should throw when vector lengths do not match', () {
        final vector = Vector.fromList([1.0, 2.0], dtype: dtype);
        final other = Vector.fromList([1.0], dtype: dtype);

        expect(() => vector.toMutable().add(other),
            throwsA(isA<VectorsLengthMismatchException>()));
      });
    });
  }
}
