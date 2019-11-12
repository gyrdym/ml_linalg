import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/simd_helper/float32x4_helper.dart';
import 'package:ml_linalg/src/vector/simd_helper/float64x2_helper.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper_factory.dart';

class SimdHelperFactoryImpl implements SimdHelperFactory {
  const SimdHelperFactoryImpl();

  @override
  SimdHelper createByDType(DType dtype) {
    switch (dtype) {
      case DType.float32:
        return const Float32x4Helper();

      case DType.float64:
        return const Float64x2Helper();

      default:
        throw UnimplementedError('Simd helper for type $dtype is not '
            'implemented yet');
    }
  }
}
