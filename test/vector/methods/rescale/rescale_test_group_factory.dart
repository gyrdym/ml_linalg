import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void vectorRescaleTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('rescale method', () {
        test('should rescale every element into range [0...1]', () {
          final vector =
              Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0], dtype: dtype);
          final actual = vector.rescale(); // min = -4, diff = 9
          final expected = [5 / 9, 2 / 9, 7 / 9, 0.0, 1.0, 4 / 9];

          expect(actual, iterableAlmostEqualTo(expected, 1e-3));
          expected
              .forEach((element) => expect(element, inInclusiveRange(0, 1)));
          expect(actual.dtype, dtype);
        });
      });
    });
