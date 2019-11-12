import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper.dart';

abstract class SimdHelperFactory {
  SimdHelper createByDType(DType dtype);
}
