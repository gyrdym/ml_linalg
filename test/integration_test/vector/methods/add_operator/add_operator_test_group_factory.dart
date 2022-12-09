import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorAddOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('+ operator', () {
        test('should perform addition of a vector', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final actual = vector1 + vector2;
          final expected = [2.0, 4.0, 6.0, 8.0, 10.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform addition of a vector of different dtype', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtypeToInverseDType[dtype]!);

          final actual = vector1 + vector2;
          final expected = [2.0, 4.0, 6.0, 8.0, 10.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform addition of a list', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final actual = vector1 + [1.0, 2.0, 3.0, 4.0, 5.0];
          final expected = [2.0, 4.0, 6.0, 8.0, 10.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test(
            'should throw an exception if one tries to add vectors of different '
            'lengths', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);

          expect(() => vector1 + vector2,
              throwsA(isA<VectorsLengthMismatchException>()));
        });

        test('should perform addition of a column matrix', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [1.0],
            [2.0],
            [3.0],
            [4.0],
            [5.0],
          ], dtype: dtype);

          final actual = vector + matrix;
          final expected = [2.0, 4.0, 6.0, 8.0, 10.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform addition of a rows matrix', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0]
          ], dtype: dtype);

          final actual = vector + matrix;
          final expected = [2.0, 4.0, 6.0, 8.0, 10.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform addition with a scalar', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final result = vector + 13.0;

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([14.0, 15.0, 16.0, 17.0, 18.0]));
        });
      });
    });
