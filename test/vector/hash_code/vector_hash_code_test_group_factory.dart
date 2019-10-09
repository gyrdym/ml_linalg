import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../dtype_to_class_name_mapping.dart';

void vectorHashCodeTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('hashCode', () {
        test('should return the same hashcode for equal vectors, case 1', () {
          final hash1 = Vector
              .fromList([0, 0, 0, 0, 1], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([0, 0, 0, 0, 1], dtype: dtype)
              .hashCode;
          expect(hash1, equals(hash2));
        });

        test('should return the same hashcode for equal vectors, case 2', () {
          final hash1 = Vector
              .fromList([-10, double.infinity, 345, 20, 1], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([-10, double.infinity, 345, 20, 1], dtype: dtype)
              .hashCode;
          expect(hash1, equals(hash2));
        });

        test('should return the same hashcode for equal vectors, case 3', () {
          final hash1 = Vector
              .fromList([0, 0, 0, 0, 0], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([0, 0, 0, 0, 0], dtype: dtype)
              .hashCode;
          expect(hash1, equals(hash2));
        });

        test('should return the same hashcode for equal vectors, case 4', () {
          final hash1 = Vector
              .fromList([], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([], dtype: dtype)
              .hashCode;
          expect(hash1, equals(hash2));
        });

        test('should return the same hashcode for equal vectors, case 5', () {
          final hash1 = Vector
              .fromList([100], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([100], dtype: dtype)
              .hashCode;
          expect(hash1, equals(hash2));
        });

        test(
            'should return a different hashcode for unequal vectors, case 1', () {
          final hash1 = Vector
              .fromList([0, 0, 0, 1, 0], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([0, 0, 0, 0, 1], dtype: dtype)
              .hashCode;
          expect(hash1, isNot(equals(hash2)));
        });

        test(
            'should return a different hashcode for unequal vectors, case 2', () {
          final hash1 = Vector
              .fromList([0, 0, 0, 10, 0], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([0, 0, 0, 1, 0, 0], dtype: dtype)
              .hashCode;
          expect(hash1, isNot(equals(hash2)));
        });

        test(
            'should return a different hashcode for unequal vectors, case 3', () {
          final hash1 = Vector
              .fromList([-32, 12, 0, 10, 0], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([32, 12, 0, 10, 0], dtype: dtype)
              .hashCode;
          expect(hash1, isNot(equals(hash2)));
        });

        test(
            'should return a different hashcode for unequal vectors, case 4', () {
          final hash1 = Vector
              .fromList([32, 5, 46, 78, 9], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([3, 25, 46, 7, 89], dtype: dtype)
              .hashCode;
          expect(hash1, isNot(equals(hash2)));
        });

        test(
            'should return a different hashcode for unequal vectors, case 5', () {
          final hash1 = Vector
              .fromList([32.04999923706055, 0.5, 2.0, 11.5], dtype: dtype)
              .hashCode;
          final hash2 = Vector
              .fromList([32.0, 49999237060550.5, 2.0, 11.5], dtype: dtype)
              .hashCode;
          expect(hash1, isNot(equals(hash2)));
        });
      });
    });
