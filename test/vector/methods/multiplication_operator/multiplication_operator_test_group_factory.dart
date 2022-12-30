import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorMultiplicationOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('* operator', () {
        test('should perform multiplication by another vector', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final actual = vector1 * vector2;

          expect(actual, equals([1.0, 4.0, 9.0, 16.0, 25.0]));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform multiplication by a vector of different dtype',
            () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtypeToInverseDType[dtype]!);

          final actual = vector1 * vector2;

          expect(actual, equals([1.0, 4.0, 9.0, 16.0, 25.0]));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should perform multiplication by a list', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final actual = vector1 * [1.0, 2.0, 3.0, 4.0, 5.0];

          expect(actual, equals([1.0, 4.0, 9.0, 16.0, 25.0]));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test(
            'should throw an error if one tries to multiple by a vector of '
            'inappropriate length', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);

          expect(() => vector1 * vector2,
              throwsA(isA<VectorsLengthMismatchException>()));
        });

        test('should perform multiplication by a matrix', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [2.0, 3.0],
            [4.0, 5.0],
            [6.0, 7.0],
          ], dtype: dtype);

          final actual = vector * matrix;
          final expected = [28.0, 34.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(2));
          expect(actual.dtype, dtype);
        });

        test(
            'should throw an exception if one tries to multiple by a '
            'matrix with inappropriate dimension', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [2.0, 3.0],
            [4.0, 5.0],
          ], dtype: dtype);

          final actual = () => vector * matrix;

          expect(actual, throwsException,
              reason: 'the matrix has different row number than the vector');
        });

        test('should perform multiplication with a scalar', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final result = vector * 2.0;

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([2.0, 4.0, 6.0, 8.0, 10.0]));
          expect(result.dtype, dtype);
        });
      });
    });
