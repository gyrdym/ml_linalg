import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixToVectorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('toVector method', () {
        test('should convert matrix to vector column', () {
          final matrix = Matrix.fromList([
            [1.0],
            [5.0],
            [9.0],
          ], dtype: dtype);

          final column1 = matrix.toVector();
          final column2 = matrix.toVector();

          expect(column1 is Vector, isTrue);
          expect(column1, equals([1.0, 5.0, 9.0]));
          expect(column1, same(column2));
          expect(column1.dtype, dtype);
        });

        test('should convert matrix to vector row', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0],
          ], dtype: dtype);

          final row1 = matrix.toVector();
          final row2 = matrix.toVector();

          expect(row1 is Vector, isTrue);
          expect(row1, equals([4.0, 8.0, 12.0, 16.0]));
          expect(row1, same(row2));
          expect(row1.dtype, dtype);
        });

        test('should throw an error if one tries to convert matrix into '
            'vector if the matrix dimension is inappropriate', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0],
            [20.0, 24.0, 28.0, 32.0],
            [36.0, .0, -8.0, -12.0],
          ], dtype: dtype);

          // ignore: unnecessary_lambdas
          expect(() => matrix.toVector(), throwsException);
        });
      });
    });
