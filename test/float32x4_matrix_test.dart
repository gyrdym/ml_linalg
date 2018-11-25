import 'package:linalg/src/simd/matrix/float32/float32x4_matrix.dart';
import 'package:test/test.dart';

void main() {
  group('Float32x4Matrix', () {
    group('`from ` constructor', () {
      test('should create matrix based on given iterable value', () {
        final actual = Float32x4Matrix.from([
          [1.0, 2.0, 3.0, 4.0, 5.0],
          [6.0, 7.0, 8.0, 9.0, 0.0],
        ]);
        final expected = [
          [1.0, 2.0, 3.0, 4.0, 5.0],
          [6.0, 7.0, 8.0, 9.0, 0.0],
        ];
        expect(actual, equals(expected));
      });

      test('should create a new iterator for newly createdmatrix', () {
        final iterable = [[1.0, 2.0, 3.0, 4.0, 5.0]];
        final matrix = Float32x4Matrix.from(iterable);
        expect(identical(matrix.iterator, iterable.iterator), isFalse);
      });
    });
  });
}