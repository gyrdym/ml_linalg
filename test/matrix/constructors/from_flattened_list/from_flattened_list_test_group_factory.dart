import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixFromFlattenedListConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('fromFlattenedList constructor', () {
        test('should create an instance from flattened collection', () {
          final actual =
            Matrix.fromFlattenedList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 2, 3,
                dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
          ];

          expect(actual.rowsNum, 2);
          expect(actual.columnsNum, 3);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should create an instance based on an empty list', () {
          final actual = Matrix.fromFlattenedList([], 0, 0, dtype: dtype);
          final expected = <double>[];

          expect(actual.rowsNum, 0);
          expect(actual.columnsNum, 0);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should throw an error if one tries to create a matrix from '
            'flattened collection with unproper dimension', () {
          expect(() => Matrix
              .fromFlattenedList([1.0, 2.0, 3.0, 4.0, 5.0], 2, 3, dtype: dtype),
              throwsException);
        });
      });
    });