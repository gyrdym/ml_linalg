import 'package:ml_linalg/matrix.dart';

abstract class MLMatrixValidator {
  void checkDimensions(MLMatrix first, MLMatrix second,
      {String errorTitle = 'Cannot perform the operation'});
  void checkColumnsAndRowsNumber(MLMatrix first, MLMatrix second,
      {String errorTitle = 'Cannot perform the operation'});
}
