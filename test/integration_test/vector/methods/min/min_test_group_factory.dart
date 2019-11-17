import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorMinTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('min method', () {
        test('should find the minimal element for the vector with more than 4 '
            'elements', () {
          final vector = Vector.fromList([10.0, 1.0, 4.0, 7.0, 9.0, 1.0],
              dtype: dtype);

          expect(vector.min(), 1.0);
        });

        test('should find the minimal element for the vector with 4 '
            'elements', () {
          final vector = Vector.fromList([10.0, 0.0, 4.0, 7.0], dtype: dtype);

          expect(vector.min(), 0.0);
        });

        test('should find the minimal element for the vector with length that '
            'is less than 4', () {
          final vector = Vector.fromList([10.0, 1.0, 4.0], dtype: dtype);

          expect(vector.min(), 1.0);
        });
      });
    });
