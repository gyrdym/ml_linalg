import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorFromListConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('fromList constructor', () {
        test(
            'should create a vector from dynamic-length list, length is '
            'greater than 4', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);

          expect(vector, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));
          expect(vector.length, equals(6));
          expect(vector.dtype, dtype);
        });

        test(
            'should create a vector from dynamic-length list, length is less '
            'than 4', () {
          final vector = Vector.fromList([1.0, 2.0], dtype: dtype);

          expect(vector, equals([1.0, 2.0]));
          expect(vector.length, equals(2));
          expect(vector.dtype, dtype);
        });

        test(
            'should create a vector from fixed-length list, length is greater '
            'than 4', () {
          final vector = Vector.fromList(List.filled(11, 1.0), dtype: dtype);

          expect(vector,
              equals([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]));
          expect(vector.length, 11);
          expect(vector.dtype, dtype);
        });

        test(
            'should create a vector from fixed-length list, length is less '
            'than 4', () {
          final vector = Vector.fromList(List.filled(1, 2.0), dtype: dtype);

          expect(vector, equals([2.0]));
          expect(vector.length, 1);
          expect(vector.dtype, dtype);
        });

        test('should create a vector from an empty list', () {
          final vector = Vector.fromList([], dtype: dtype);

          expect(vector, equals(<double>[]));
          expect(vector.length, 0);
          expect(vector.dtype, dtype);
        });

        test(
            'should provide correct size of vectors when summing up, length is 3',
            () {
          final vector1 = Vector.fromList([1, 2, 3], dtype: dtype);
          final vector2 = Vector.fromList([3, 4, 5], dtype: dtype);
          final vector = vector1 + vector2;

          expect(vector, equals(<double>[4, 6, 8]));
          expect(vector.length, 3);
          expect(vector.dtype, dtype);
        });

        test(
            'should provide correct size of vectors when summing up, length is 5',
            () {
          final vector1 = Vector.fromList([1, 2, 3, 4, 5], dtype: dtype);
          final vector2 = Vector.fromList([3, 4, 5, 6, 7], dtype: dtype);
          final vector = vector1 + vector2;

          expect(vector, equals(<double>[4, 6, 8, 10, 12]));
          expect(vector.length, 5);
          expect(vector.dtype, dtype);
        });

        test(
            'should create a vector from a typed list, length is greater than 4',
            () {
          final source = dtype == DType.float32
              ? Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
              : Float64List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
          final vector = Vector.fromList(source, dtype: dtype);

          expect(vector, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));
          expect(vector.length, 6);
          expect(vector.dtype, dtype);
        });

        test('should create a vector from a typed list, length is less than 4',
            () {
          final source = dtype == DType.float32
              ? Float32List.fromList([1.0, 2.0, 3.0])
              : Float64List.fromList([1.0, 2.0, 3.0]);
          final vector = Vector.fromList(source, dtype: dtype);

          expect(vector, equals([1.0, 2.0, 3.0]));
          expect(vector.length, 3);
          expect(vector.dtype, dtype);
        });

        test('should keep SIMD padding zeros when created from a typed list',
            () {
          final source = dtype == DType.float32
              ? Float32List.fromList([1.0, 2.0, 3.0])
              : Float64List.fromList([1.0, 2.0, 3.0]);
          final vector = Vector.fromList(source, dtype: dtype);

          expect(vector.sum(), 6.0);
        });

        test('should create a vector from a mixed List<num>', () {
          final source = <num>[1, 2.5, 3, 4.25, 5];
          final vector = Vector.fromList(source, dtype: dtype);

          expect(vector, equals([1.0, 2.5, 3.0, 4.25, 5.0]));
          expect(vector.length, 5);
          expect(vector.dtype, dtype);
        });
      });
    });
