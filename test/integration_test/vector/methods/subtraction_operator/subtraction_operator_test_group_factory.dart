import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorSubtractionOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('- operator', () {
        test('should perform subtraction with another vector', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final result = vector1 - vector2;

          expect(result, equals([0.0, 0.0, 0.0, 0.0, 0.0]));
          expect(result.length, equals(5));
          expect(result.dtype, dtype);
        });

        test(
            'should throw an exception if one tries to subtract a vector of '
            'inappropriate length', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);

          expect(() => vector1 - vector2,
              throwsA(isA<VectorsLengthMismatchException>()));
        });

        test('should perform subtraction with a column matrix', () {
          final vector =
              Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [1.0],
            [2.0],
            [3.0],
            [4.0],
            [5.0],
          ], dtype: dtype);

          final actual = vector - matrix;
          final expected = [1.0, 4.0, 9.0, 11.0, 13.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform subtraction with a row matrix', () {
          final vector =
              Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0]
          ], dtype: dtype);

          final actual = vector - matrix;
          final expected = [1.0, 4.0, 9.0, 11.0, 13.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform subtruction with a scalar', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final result = vector - 13.0;

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
          expect(result.dtype, dtype);
        });
      });
    });
