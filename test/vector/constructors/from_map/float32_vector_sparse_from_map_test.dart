import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/vector/float32_vector_sparse.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  group('Float32VectorSparse.fromMap', () {
    test('should create a sparse vector with implicit zeros', () {
      final vector = Float32VectorSparse.fromMap(
        {0: 1.0, 3: 2.5, 5: -1.0},
        length: 6,
      );

      expect(vector, isA<Vector>());
      expect(vector.dtype, DType.float32);
      expect(vector.length, 6);
      expect(vector.nnz, 3);
      expect(vector.toList(), [1.0, 0.0, 0.0, 2.5, 0.0, -1.0]);
    });

    test('should ignore explicit zeros in the source map', () {
      final vector = Float32VectorSparse.fromMap(
        {1: 0.0, 2: 4.0, 4: 0.0},
        length: 5,
      );

      expect(vector.nnz, 1);
      expect(vector.toList(), [0.0, 0.0, 4.0, 0.0, 0.0]);
    });

    test('should throw if length is negative', () {
      expect(
        () => Float32VectorSparse.fromMap({}, length: -1),
        throwsArgumentError,
      );
    });

    test('should throw if an index is out of range', () {
      expect(
        () => Float32VectorSparse.fromMap({5: 1.0}, length: 5),
        throwsRangeError,
      );
    });

    test('should support Vector arithmetic through dense fallback', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 1.0, 2: 3.0},
        length: 3,
      );
      final dense = Vector.fromList([1.0, 2.0, 3.0], dtype: DType.float32);

      expect((sparse + dense).toList(), [2.0, 2.0, 6.0]);
      expect((sparse - 1).toList(), [0.0, -1.0, 2.0]);
    });

    test('should keep sparsity for value-only maps and scalar multiplication',
        () {
      final sparse = Float32VectorSparse.fromMap(
        {1: -2.0, 3: 4.0},
        length: 5,
      );

      final absVector = sparse.abs();
      final scaled = sparse * 2;

      expect(absVector, isA<Float32VectorSparse>());
      expect(scaled, isA<Float32VectorSparse>());
      expect(absVector.toList(), [0.0, 2.0, 0.0, 4.0, 0.0]);
      expect(scaled.toList(), [0.0, -4.0, 0.0, 8.0, 0.0]);
    });

    test('should keep sqrt sparse when nnz is less than half of length', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 4.0, 3: 9.0},
        length: 5,
      );

      final rooted = sparse.sqrt();

      expect(rooted, isA<Float32VectorSparse>());
      expect(rooted.toList(), [2.0, 0.0, 0.0, 3.0, 0.0]);
    });

    test('should densify sqrt when nnz is at least half of length', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 4.0, 1: 9.0, 2: 16.0},
        length: 4,
      );

      final rooted = sparse.sqrt();

      expect(rooted, isNot(isA<Float32VectorSparse>()));
      expect(rooted.toList(), [2.0, 3.0, 4.0, 0.0]);
    });

    test('should densify abs when nnz is at least half of length', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: -1.0, 1: 2.0, 2: -3.0},
        length: 4,
      );

      final absVector = sparse.abs();

      expect(absVector, isNot(isA<Float32VectorSparse>()));
      expect(absVector.toList(), [1.0, 2.0, 3.0, 0.0]);
    });

    test('should keep positive pow sparse when nnz is less than half of length',
        () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 3: 3.0},
        length: 5,
      );

      final powered = sparse.pow(2);

      expect(powered, isA<Float32VectorSparse>());
      expect(powered.toList(), [4.0, 0.0, 0.0, 9.0, 0.0]);
    });

    test('should densify positive pow when nnz is at least half of length', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 1: 3.0, 2: 4.0},
        length: 4,
      );

      final powered = sparse.pow(2);

      expect(powered, isNot(isA<Float32VectorSparse>()));
      expect(powered.toList(), [4.0, 9.0, 16.0, 0.0]);
    });

    test('should densify scalar multiply when nnz is at least half of length',
        () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 1.0, 1: 2.0, 2: 3.0},
        length: 4,
      );

      final scaled = sparse * 2;

      expect(scaled, isNot(isA<Float32VectorSparse>()));
      expect(scaled.toList(), [2.0, 4.0, 6.0, 0.0]);
    });

    test('should keep scalar divide sparse when nnz is less than half of length',
        () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 3: 4.0},
        length: 5,
      );

      final divided = sparse / 2;

      expect(divided, isA<Float32VectorSparse>());
      expect(divided.toList(), [1.0, 0.0, 0.0, 2.0, 0.0]);
    });

    test('should densify scalar divide when nnz is at least half of length', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 1: 4.0, 2: 6.0},
        length: 4,
      );

      final divided = sparse / 2;

      expect(divided, isNot(isA<Float32VectorSparse>()));
      expect(divided.toList(), [1.0, 2.0, 3.0, 0.0]);
    });

    test('should keep vector multiply sparse when nnz is less than half of length',
        () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 3: 4.0},
        length: 5,
      );
      final other = Vector.fromList([3.0, 1.0, 1.0, 5.0, 1.0],
          dtype: DType.float32);

      final product = sparse * other;

      expect(product, isA<Float32VectorSparse>());
      expect(product.toList(), [6.0, 0.0, 0.0, 20.0, 0.0]);
    });

    test('should densify vector multiply when nnz is at least half of length',
        () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 1: 3.0, 2: 4.0},
        length: 4,
      );
      final other = Vector.fromList([5.0, 6.0, 7.0, 8.0], dtype: DType.float32);

      final product = sparse * other;

      expect(product, isNot(isA<Float32VectorSparse>()));
      expect(product.toList(), [10.0, 18.0, 28.0, 0.0]);
    });

    test('should compute sparse-friendly aggregates', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 2.0, 2: -3.0, 4: 5.0},
        length: 5,
      );

      expect(sparse.sum(), 4.0);
      expect(sparse.prod(), 0.0);
      expect(sparse.min(), -3.0);
      expect(sparse.max(), 5.0);
      expect(sparse.mean(), closeTo(0.8, 1e-6));
      expect(sparse.dot(Vector.fromList([1, 1, 1, 1, 1])), 4.0);
      expect(sparse.norm(Norm.manhattan), 10.0);
      expect(
        sparse.distanceTo(
          Vector.fromList([2, 0, -3, 0, 5]),
          distance: Distance.euclidean,
        ),
        0.0,
      );
    });

    test('should compare algebraically with another Vector by values', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 1.0, 2: 3.0},
        length: 3,
      );
      final sameSparse = Float32VectorSparse.fromMap(
        {2: 3.0, 0: 1.0},
        length: 3,
      );
      final dense = Vector.fromList([1.0, 0.0, 3.0], dtype: DType.float32);
      final different = Vector.fromList([1.0, 0.0, 4.0], dtype: DType.float32);

      expect(sparse == sameSparse, isTrue);
      expect(sparse == dense, isTrue);
      expect(sparse == different, isFalse);
      expect(sparse.hashCode, sameSparse.hashCode);
    });

    test('should update values through set and keep sparse representation', () {
      final sparse = Float32VectorSparse.fromMap(
        {0: 1.0, 2: 3.0},
        length: 4,
      );

      final updated = sparse.set(2, 0).set(1, 7) as Float32VectorSparse;

      expect(updated.nnz, 2);
      expect(updated.toList(), [1.0, 7.0, 0.0, 0.0]);
    });
  });
}
