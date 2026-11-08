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
        final result = mutable.divide(other);

        expect(result, same(mutable));
        expect(mutable.toVector(), equals([4.0, 5.0, 6.0]));
        expect(vector, equals([12.0, 20.0, 30.0]));
      });

      test('should divide vectors with 4 and 5 elements', () {
        final fourElementVector =
            Vector.fromList([12.0, 20.0, 30.0, 40.0], dtype: dtype);
        final fourElementOther =
            Vector.fromList([3.0, 4.0, 5.0, 8.0], dtype: dtype);
        final fiveElementVector =
            Vector.fromList([12.0, 20.0, 30.0, 40.0, 50.0], dtype: dtype);
        final fiveElementOther =
            Vector.fromList([3.0, 4.0, 5.0, 8.0, 10.0], dtype: dtype);

        final fourElementMutable = fourElementVector.toMutable()
          ..divide(fourElementOther);
        final fiveElementMutable = fiveElementVector.toMutable()
          ..divide(fiveElementOther);

        expect(fourElementMutable.toVector(), equals([4.0, 5.0, 6.0, 5.0]));
        expect(fiveElementMutable.toVector(), equals([4.0, 5.0, 6.0, 5.0, 5.0]));
        expect(
          fiveElementMutable.toVector() ==
              Vector.fromList([4.0, 5.0, 6.0, 5.0, 5.0], dtype: dtype),
          isTrue,
        );
      });

      test('should divide 5 elements with negative and fractional values', () {
        final vector =
            Vector.fromList([-2.5, 1.5, -4.0, 6.25, -8.5], dtype: dtype);
        final other =
            Vector.fromList([0.5, -0.5, 2.0, -2.5, 4.0], dtype: dtype);

        final mutable = vector.toMutable()..divide(other);

        expect(mutable.toVector(), equals([-5.0, -3.0, -2.0, -2.5, -2.125]));
      });

      test('should calculate the correct sum after division', () {
        final vector = Vector.fromList([1, 2, 3, 4, 5], dtype: dtype);
        final other = vectorWithPaddedTail(
          [1, 2, 3, 4, 5],
          dtype: dtype,
          paddingValue: 0,
        );

        final mutable = vector.toMutable()..divide(other);

        expect(mutable.toVector().sum(), 5);
      });

      test('should support a vector of a different dtype', () {
        final vector = Vector.fromList([8.0, 18.0], dtype: dtype);
        final other = Vector.fromList(
          [2.0, 3.0],
          dtype: dtype == DType.float32 ? DType.float64 : DType.float32,
        );

        final mutable = vector.toMutable()..divide(other);

        expect(mutable.toVector(), equals([4.0, 6.0]));
      });

      test('should throw when vector lengths do not match', () {
        final vector = Vector.fromList([1.0, 2.0], dtype: dtype);
        final other = Vector.fromList([1.0], dtype: dtype);

        expect(() => vector.toMutable().divide(other),
            throwsA(isA<VectorsLengthMismatchException>()));
      });
    });
  }
}
