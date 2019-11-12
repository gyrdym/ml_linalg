import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorMaxTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('max method', () {
        test('should find the minimal element for the vector with more than 4 '
            'elements', () {
          final vector = Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0],
              dtype: dtype);

          expect(vector.max(), 12.0);
        });

        test('should find the minimal element for the vector with 4 elements', () {
          final vector = Vector.fromList([10.0, 11.0, -4.0, 0.0],
              dtype: dtype);

          expect(vector.max(), 11.0);
        });

        test('should find the minimal element for the vector with less than 4 '
            'elements', () {
          final vector = Vector.fromList([7.0, -4.0, 0.0],
              dtype: dtype);

          expect(vector.max(), 7.0);
        });
      });
    });
