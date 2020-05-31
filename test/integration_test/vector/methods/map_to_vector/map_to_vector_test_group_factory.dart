import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorMapToVectorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('mapToVector method', () {
        test('should map to another vector', () {
          final vector = Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0],
              dtype: dtype);
          final actual = vector.mapToVector((el) => el * 2);

          expect(actual, [20, 24, 8, 14, 18, 24]);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(vector)));
        });

        test('should return empty vector if the source one is empty', () {
          final vector = Vector.fromList([], dtype: dtype);
          final actual = vector.mapToVector((el) => el * -1002);

          expect(actual, <double>[]);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(vector)));
        });
      });
    });
