import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/simd_helper/float32x4_helper.dart';
import 'package:ml_linalg/src/vector/simd_helper/float64x2_helper.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper_factory_impl.dart';
import 'package:test/test.dart';

void main() {
  group('SimdHelperFactoryImpl', () {
    final factory = const SimdHelperFactoryImpl();

    test('should create a Float32x4Helper instance', () {
      final helper = factory.createByDType(DType.float32);

      expect(helper, isA<Float32x4Helper>());
    });

    test('should create a Float64x2Helper instance', () {
      final helper = factory.createByDType(DType.float64);

      expect(helper, isA<Float64x2Helper>());
    });

    test('should throw an UnimplementedError if unexpected dtype is '
        'passed', () {
      expect(() => factory.createByDType(null), throwsUnimplementedError);
    });
  });
}
