import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorDistanceToTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('distanceTo method', () {
        test('should find Euclidean distance (from vector to the same vector)', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0], dtype: dtype);
          final distance = vector.distanceTo(vector);

          expect(distance, equals(0.0),
              reason: 'Wrong vector distance calculation');
        });

        test('should find Euclidean distance', () {
          final vector1 = Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0],
              dtype: dtype);
          final vector2 = Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5],
              dtype: dtype);

          expect(vector1.distanceTo(vector2, distance: Distance.euclidean),
              equals(10.88577052853862));
        });

        test('should find Manhattan distance', () {
          final vector1 = Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0],
              dtype: dtype);
          final vector2 = Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5],
              dtype: dtype);

          expect(vector1.distanceTo(vector2, distance: Distance.manhattan),
              equals(20.0));
        });

        test('should find cosine distance (the same vectors)', () {
          final vector1 = Vector.fromList([1.0, 0.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 0.0], dtype: dtype);

          expect(vector1.distanceTo(vector2, distance: Distance.cosine),
              equals(0.0));
        });

        test('should find cosine distance (different vectors)', () {
          final vector1 = Vector.fromList([4.0, 3.0], dtype: dtype);
          final vector2 = Vector.fromList([2.0, 4.0], dtype: dtype);

          expect(vector1.distanceTo(vector2, distance: Distance.cosine),
              closeTo(0.1055, 1e-4));
        });

        test('should find cosine distance (different vectors with negative '
            'elements)', () {
          final vector1 = Vector.fromList([4.0, -3.0], dtype: dtype);
          final vector2 = Vector.fromList([-2.0, 4.0], dtype: dtype);

          expect(vector1.distanceTo(vector2, distance: Distance.cosine),
              closeTo(1.8944, 1e-4));
        });

        test('should find cosine distance (one of two vectors is '
            'zero-vector)', () {
          final vector1 = Vector.fromList([0.0, 0.0], dtype: dtype);
          final vector2 = Vector.fromList([-2.0, 4.0], dtype: dtype);

          expect(() => vector1.distanceTo(vector2, distance: Distance.cosine),
              throwsException);
        });
      });
    });
