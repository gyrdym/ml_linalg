import 'dart:typed_data';

import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/src/vector/common/simd_helper_factory.dart';
import 'package:ml_linalg/src/vector/float32/simd_helper/float32x4_helper.dart';

class Float32x4HelperFactory implements
    SimdHelperFactory<Float32x4, Float32x4List> {

  const Float32x4HelperFactory();

  @override
  SimdHelper<Float32x4, Float32x4List> create() => Float32x4Helper();
}
