import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorMinTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('min method', () {
        test('should find a minimal element for the vector with more than 4 '
            'elements', () {
          final vector = Vector.fromList([10.0, 1.0, 4.0, 7.0, 9.0, 1.0],
              dtype: dtype);

          expect(vector.min(), 1.0);
          expect(vector.dtype, dtype);
        });

        test('should find a minimal element for the vector with 4 '
            'elements', () {
          final vector = Vector.fromList([10.0, 0.0, 4.0, 7.0], dtype: dtype);

          expect(vector.min(), 0.0);
          expect(vector.dtype, dtype);
        });

        test('should find a minimal element for the vector with length that is '
            'less than 4', () {
          final vector = Vector.fromList([10.0, 1.0, 4.0], dtype: dtype);

          expect(vector.min(), 1.0);
          expect(vector.dtype, dtype);
        });
      });
    });
