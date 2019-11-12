import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorAbsOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('abs method', () {
        test('should find vector elements absolute value', () {
          final vector = Vector.fromList([-3.0, 4.5, -12.0, -23.5, 44.0],
              dtype: dtype);
          final result = vector.abs();

          expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
          expect(result, isNot(vector));
          expect(result.dtype, dtype);
        });
      });
    });
