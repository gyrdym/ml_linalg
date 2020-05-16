import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_from_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_2d_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('fromMatrixJson', () {
    final data = <List<double>>[
      [1.0, 2.0, 4.0, 5.0],
      [-100.0, 4.89, 191, -10000],
      [33, -987, 90, 732],
    ];

    final emptyData = <List<double>>[];
    final dataWithEmptyRow = <List<double>>[[]];

    final jsonWithoutData = {
      dTypeJsonKey: dTypeFloat64EncodedValue,
    };

    final jsonWithoutDType = {
      dataJsonKey: data,
    };

    final validFloat32Json = {
      dTypeJsonKey: dTypeFloat32EncodedValue,
      dataJsonKey: data,
    };

    final validFloat64Json = {
      dTypeJsonKey: dTypeFloat64EncodedValue,
      dataJsonKey: data,
    };

    final validFloat32JsonWithEmptyData = {
      dTypeJsonKey: dTypeFloat32EncodedValue,
      dataJsonKey: emptyData,
    };

    final validFloat32JsonWithEmptyRow = {
      dTypeJsonKey: dTypeFloat32EncodedValue,
      dataJsonKey: dataWithEmptyRow,
    };

    test('should throw an error if data key is absent', () {
      final actual = () => fromMatrixJson(jsonWithoutData);
      expect(actual, throwsException);
    });

    test('should throw an error if dtype key is absent', () {
      final actual = () => fromMatrixJson(jsonWithoutDType);
      expect(actual, throwsException);
    });

    test('should restore a float 32 matrix instance from json', () {
      final matrix = fromMatrixJson(validFloat32Json);
      expect(matrix.dtype, DType.float32);
      expect(matrix, iterable2dAlmostEqualTo([
        [1.0, 2.0, 4.0, 5.0],
        [-100.0, 4.89, 191, -10000],
        [33, -987, 90, 732],
      ]));
    });

    test('should restore a float 64 matrix instance from json', () {
      final matrix = fromMatrixJson(validFloat64Json);
      expect(matrix.dtype, DType.float64);
      expect(matrix, iterable2dAlmostEqualTo([
        [1.0, 2.0, 4.0, 5.0],
        [-100.0, 4.89, 191, -10000],
        [33, -987, 90, 732],
      ]));
    });

    test('should restore a float 32 matrix from json with empty data', () {
      final matrix = fromMatrixJson(validFloat32JsonWithEmptyData);
      expect(matrix, <List<double>>[]);
    });

    test('should restore a float 32 matrix from json with data consisting of '
        'just empty row', () {
      final matrix = fromMatrixJson(validFloat32JsonWithEmptyRow);
      expect(matrix, <List<double>>[]);
    });
  });
}
