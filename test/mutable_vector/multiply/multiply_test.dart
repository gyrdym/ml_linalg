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
        final result = mutable.multiply(other);

        expect(result, same(mutable));
        expect(mutable.toVector(), equals([36.0, 80.0, 150.0]));
        expect(vector, equals([12.0, 20.0, 30.0]));
      });

      test('should multiply vectors with 4 and 5 elements', () {
        final fourElementVector =
            Vector.fromList([12.0, 20.0, 30.0, 40.0], dtype: dtype);
        final fourElementOther =
            Vector.fromList([3.0, 4.0, 5.0, 6.0], dtype: dtype);
        final fiveElementVector =
            Vector.fromList([12.0, 20.0, 30.0, 40.0, 50.0], dtype: dtype);
        final fiveElementOther =
            Vector.fromList([3.0, 4.0, 5.0, 6.0, 7.0], dtype: dtype);

        final fourElementMutable = fourElementVector.toMutable()
          ..multiply(fourElementOther);
        final fiveElementMutable = fiveElementVector.toMutable()
          ..multiply(fiveElementOther);

        expect(fourElementMutable.toVector(), equals([36.0, 80.0, 150.0, 240.0]));
        expect(
          fiveElementMutable.toVector(),
          equals([36.0, 80.0, 150.0, 240.0, 350.0]),
        );
      });

      test('should multiply 5 elements with negative and fractional values',
          () {
        final vector =
            Vector.fromList([-2.5, 1.5, -4.0, 6.25, -8.5], dtype: dtype);
        final other =
            Vector.fromList([1.5, -2.0, 0.25, -0.5, 2.0], dtype: dtype);

        final mutable = vector.toMutable()..multiply(other);

        expect(mutable.toVector(), equals([-3.75, -3.0, -1.0, -3.125, -17.0]));
      });

      test('should calculate the correct sum after multiplication', () {
        final vector = Vector.fromList([1, 2, 3, 4, 5], dtype: dtype);
        final other = vectorWithPaddedTail(
          [2, 3, 4, 5, 6],
          dtype: dtype,
          paddingValue: double.nan,
        );

        final mutable = vector.toMutable()..multiply(other);

        expect(mutable.toVector().sum(), 70);
      });

      test('should support a vector of a different dtype', () {
        final vector = Vector.fromList([8.0, 18.0], dtype: dtype);
        final other = Vector.fromList(
          [2.0, 3.0],
          dtype: dtype == DType.float32 ? DType.float64 : DType.float32,
        );

        final mutable = vector.toMutable()..multiply(other);

        expect(mutable.toVector(), equals([16.0, 54.0]));
      });

      test('should throw when vector lengths do not match', () {
        final vector = Vector.fromList([1.0, 2.0], dtype: dtype);
        final other = Vector.fromList([1.0], dtype: dtype);

        expect(() => vector.toMutable().multiply(other),
            throwsA(isA<VectorsLengthMismatchException>()));
      });
    });
  }
}
