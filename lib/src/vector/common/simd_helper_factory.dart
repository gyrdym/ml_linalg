import 'package:ml_linalg/src/vector/common/simd_helper.dart';

abstract class SimdHelperFactory<E, S extends List<E>> {
  SimdHelper<E, S> create();
}