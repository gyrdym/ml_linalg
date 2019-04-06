import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

mixin MatrixFastIterableMixin implements Matrix {
  @override
  Matrix fastMap<T>(T mapper(T element)) {
    final source = List<Vector>.generate(
        rowsNum,
        (int i) => (getRow(i)).fastMap(
            (T element, int startOffset, int endOffset) => mapper(element)));
    return Matrix.fromRows(source, dtype: dtype);
  }
}
