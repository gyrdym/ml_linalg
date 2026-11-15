import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

String matrixTestTitle(DType dtype) => 'with $dtype storage';

Matrix matrixFromRows(List<List<double>> rows, DType dtype) =>
    Matrix.fromList(rows, dtype: dtype);

List<List<double>> matrixValues(Iterable<Iterable<double>> matrix) =>
    matrix.map((row) => row.toList()).toList();

void expectMatrixClose(
  Iterable<Iterable<double>> actual,
  List<List<double>> expected, {
  double tolerance = 1e-5,
}) {
  final actualRows = matrixValues(actual);
  expect(actualRows, hasLength(expected.length));

  for (var row = 0; row < expected.length; row++) {
    expect(actualRows[row], hasLength(expected[row].length));
    for (var column = 0; column < expected[row].length; column++) {
      expect(actualRows[row][column], closeTo(expected[row][column], tolerance));
    }
  }
}
