import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorSubtractionOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('- operator', () {
        test('should perform subtraction of another vector', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final result = vector1 - vector2;

          expect(result, equals([0.0, 0.0, 0.0, 0.0, 0.0]));
          expect(result.length, equals(5));
          expect(result.dtype, dtype);
        });

        test('should throw an exception if one tries to subtract a vector of '
            'inappropriate length', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);

          expect(() => vector1 - vector2, throwsRangeError);
        });

        test('should perform subtraction of a column matrix', () {
          final vector = Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0]);
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

        test('should perform subtraction of a row matrix', () {
          final vector = Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0], dtype: dtype);
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0]
          ], dtype: dtype);

          final actual = vector - matrix;
          final expected = [1.0, 4.0, 9.0, 11.0, 13.0];

          expect(actual, equals(expected));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });
      });
    });
