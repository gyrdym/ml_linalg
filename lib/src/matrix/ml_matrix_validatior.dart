import 'package:ml_linalg/matrix.dart';

abstract class MLMatrixValidator<E> {
  void checkDimensions(MLMatrix<E> first, MLMatrix<E> second, {String errorTitle = 'Cannot perform the operation'});
  void checkColumnsAndRowsNumber(MLMatrix<E> first, MLMatrix<E> second,
      {String errorTitle = 'Cannot perform the operation'});
}
