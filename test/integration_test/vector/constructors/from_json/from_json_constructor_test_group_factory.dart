import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/dtype_to_json.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void fromJsonConstructorTestGroupFactory(DType dtype) =>
  group(dtypeToVectorTestTitle[dtype], () {
    group('fromJson constructor', () {
      final data = <double>[12, 23, 44.0, -1e10, 10007.888, -10, 0, 7];
      final json = {
        vectorDTypeJsonKey: dTypeToJson(dtype),
        vectorDataJsonKey: data,
      };
      final unknownJson = {
        vectorDTypeJsonKey: 'some_unknown_dtype',
        vectorDataJsonKey: data,
      };

      test('should decode serialized vector', () {
        final vector = Vector.fromJson(json);

        expect(vector, iterableAlmostEqualTo(data, 1e-3));
        expect(vector.dtype, dtype);
      });

      test('should throw an error if unknown decoded value is passed', () {
        final actual = () => Vector.fromJson(unknownJson);

        expect(actual, throwsUnsupportedError);
      });
    });
  });
