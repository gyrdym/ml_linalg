import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/dtype_to_json.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void vectorToJsonTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('toJson method', () {
        final data = <double>[100, 129, 3.555, 5.07, -600, 17, 84];
        final vector = Vector.fromList(data, dtype: dtype);

        test('should return a json-serializable map', () {
          final encoded = vector.toJson();

          expect(encoded[vectorDTypeJsonKey], dTypeToJson(dtype));
          expect(encoded[vectorDataJsonKey], iterableAlmostEqualTo(data));
          expect(encoded.keys, hasLength(2));
        });
      });
    });
