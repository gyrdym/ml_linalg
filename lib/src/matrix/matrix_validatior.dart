import 'package:ml_linalg/matrix.dart';

abstract class MatrixValidator {
  void checkDimensions(Matrix first, Matrix second,
      {String errorTitle = 'Cannot perform the operation'});
  void checkColumnsAndRowsNumber(Matrix first, Matrix second,
      {String errorTitle = 'Cannot perform the operation'});
}
