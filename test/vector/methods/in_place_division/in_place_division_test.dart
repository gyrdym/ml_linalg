import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(dtypeToVectorTestTitle[dtype], () {
      test('should mutate and return the original vector', () {
        final vector = Vector.fromList([12.0, 20.0, 30.0], dtype: dtype);
        final other = Vector.fromList([3.0, 4.0, 5.0], dtype: dtype);
        final result = vector.divideInPlace(other);

        expect(result, same(vector));
        expect(vector, equals([4.0, 5.0, 6.0]));
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

        fourElementVector.divideInPlace(fourElementOther);
        fiveElementVector.divideInPlace(fiveElementOther);

        expect(fourElementVector, equals([4.0, 5.0, 6.0, 5.0]));
        expect(fiveElementVector, equals([4.0, 5.0, 6.0, 5.0, 5.0]));
        expect(
          fiveElementVector ==
              Vector.fromList([4.0, 5.0, 6.0, 5.0, 5.0], dtype: dtype),
          isTrue,
        );
      });

      test('should divide 5 elements with negative and fractional values', () {
        final vector =
            Vector.fromList([-2.5, 1.5, -4.0, 6.25, -8.5], dtype: dtype);
        final other =
            Vector.fromList([0.5, -0.5, 2.0, -2.5, 4.0], dtype: dtype);

        vector.divideInPlace(other);

        expect(vector, equals([-5.0, -3.0, -2.0, -2.5, -2.125]));
      });

      test('should support a vector of a different dtype', () {
        final vector = Vector.fromList([8.0, 18.0], dtype: dtype);
        final other = Vector.fromList(
          [2.0, 3.0],
          dtype: dtype == DType.float32 ? DType.float64 : DType.float32,
        );

        vector.divideInPlace(other);

        expect(vector, equals([4.0, 6.0]));
      });

      test('should throw when vector lengths do not match', () {
        final vector = Vector.fromList([1.0, 2.0], dtype: dtype);
        final other = Vector.fromList([1.0], dtype: dtype);

        expect(() => vector.divideInPlace(other),
            throwsA(isA<VectorsLengthMismatchException>()));
      });
    });
  }
}
