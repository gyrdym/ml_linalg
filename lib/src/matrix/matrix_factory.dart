import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class MatrixFactory {
  Matrix fromList(DType dtype, List<List<double>> source);
  Matrix fromRows(DType dtype, List<Vector> source);
  Matrix fromColumns(DType dtype, List<Vector> source);
  Matrix empty(DType dtype);
  Matrix fromFlattenedList(
      DType dtype, List<double> source, int rowsNum, int columnsNum);
  Matrix diagonal(DType dtype, List<double> source);
  Matrix scalar(DType dtype, double scalar, int size);
  Matrix identity(DType dtype, int size);
  Matrix row(DType dtype, List<double> source);
  Matrix column(DType dtype, List<double> source);
  Matrix random(DType dtype, int rowsNum, int columnsNum,
      {num min, num max, int? seed});
}
