import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void filterElementsTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('filterElements method', () {
        test('should filter elements by index', () {
          final vector =
              Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual = vector.filterElements((_, idx) => idx % 2 == 0);

          expect(actual, [10, 4, 9]);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(vector)));
        });

        test('should filter elements by element', () {
          final vector =
              Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual =
              vector.filterElements((element, _) => element % 2 == 0);

          expect(actual, [10, 12, 4, 12]);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(vector)));
        });
      });
    });
