import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixFastIterableMixin implements MLMatrixFactory, MLMatrix {
  @override
  MLMatrix fastMap<T>(T mapper(T element)) {
    final source = List<MLVector>.generate(rowsNum, (int i) => (getRow(i))
        .fastMap((T element, int startOffset, int endOffset) => mapper(element)));
    return createMatrixFromRows(source);
  }
}