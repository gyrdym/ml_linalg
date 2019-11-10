import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorSumTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('sum method', () {
        test('should find vector elements sum', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);

          expect(vector.sum(), equals(15.0));
        });
      });
    });
