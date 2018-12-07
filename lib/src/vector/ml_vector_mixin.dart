import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/vector/ml_vector_data_store.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/src/vector/simd_data_helper.dart';
import 'package:ml_linalg/src/vector/typed_data_helper.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLVectorMixin<E, T extends List<double>, S extends List<E>> implements
    IterableMixin<double>,
    SIMDDataHelper<S, E>,
    TypedDataHelper<T>,
    MLVectorDataStore<S, E>,
    MLVectorFactory<S, E>,
    MLVector<E> {

  S get dataWithoutLastBucket => sublist(data, 0, data.length - 1);

  @override
  Iterator<double> get iterator => getIterator((data as TypedData).buffer, length);

  int get _bucketsNumber => data.length;

  bool get _isLastBucketNotFull => length % bucketSize > 0;

  @override
  MLVector<E> operator +(Object value) {
    if (value is MLVector<E>) {
      return _elementWiseVectorOperation(value, simdSum);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(createSIMDFilled(value.toDouble()), simdSum);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  MLVector<E> operator -(Object value) {
    if (value is MLVector<E>) {
      return _elementWiseVectorOperation(value, simdSub);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(createSIMDFilled(value.toDouble()), simdSub);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  MLVector<E> operator *(Object value) {
    if (value is MLVector<E>) {
      return _elementWiseVectorOperation(value, simdMul);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(value.toDouble(), simdScale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  MLVector<E> operator /(Object value) {
    if (value is MLVector<E>) {
      return _elementWiseVectorOperation(value, simdDiv);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(1 / value, simdScale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  MLVector<E> toIntegerPower(int power) => _elementWisePow(power);

  /// Returns a vector filled with absolute values of an each component of [this] vector
  @override
  MLVector<E> abs() => _elementWiseSelfOperation(simdAbs);

  @override
  MLVector<E> copy() => _elementWiseSelfOperation((E value) => value);

  @override
  double dot(MLVector<E> vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => singleSIMDSum(data.reduce(simdSum));

  @override
  double distanceTo(MLVector<E> vector, [Norm norm = Norm.euclidean]) => (this - vector).norm(norm);

  @override
  double mean() => sum() / length;

  @override
  double norm([Norm norm = Norm.euclidean]) {
    final power = _getPowerByNormType(norm);
    if (power == 1) {
      return abs().sum();
    }
    return math.pow(toIntegerPower(power).sum(), 1 / power) as double;
  }

  @override
  double max() {
    if (_isLastBucketNotFull) {
      var max = -double.infinity;
      final listOnlyWithFullBuckets = dataWithoutLastBucket;
      if (listOnlyWithFullBuckets.isNotEmpty) {
        max = getMaxLane(listOnlyWithFullBuckets.reduce(selectMax));
      }
      return simdToList(data.last)
          .take(length % bucketSize)
          .fold(max, math.max);
    } else {
      return getMaxLane(data.reduce(selectMax));
    }
  }

  @override
  double min() {
    if (_isLastBucketNotFull) {
      var min = double.infinity;
      final listOnlyWithFullBuckets = dataWithoutLastBucket;
      if (listOnlyWithFullBuckets.isNotEmpty) {
        min = getMinLane(listOnlyWithFullBuckets.reduce(selectMin));
      }
      return simdToList(data.last)
          .take(length % bucketSize)
          .fold(min, math.min);
    } else {
      return getMinLane(data.reduce(selectMin));
    }
  }

  @override
  MLVector<E> query(Iterable<int> indexes) {
    final list = createTypedList(indexes.length);
    int i = 0;
    for (final idx in indexes) {
      list[i++] = this[idx];
    }
    return vectorFrom(list);
  }

  @override
  MLVector<E> unique() {
    final unique = <double>[];
    for (int i = 0; i < length; i++) {
      final el = this[i];
      if (!unique.contains(el)) {
        unique.add(el);
      }
    }
    return vectorFrom(unique);
  }

  @override
  double operator [](int index) {
    if (index >= length) throw RangeError.index(index, this);
    final base = (index / bucketSize).floor();
    final offset = index - base * bucketSize;
    return getScalarByOffsetIndex(data[base], offset);
  }

  @override
  MLVector<E> vectorizedMap(E mapper(E el)) => _elementWiseSelfOperation(mapper);

  @override
  MLVector<E> subvector(int start, [int end]) {
    final collection = bufferAsTypedList(
        (data as TypedData).buffer, start, (end > length ? length : end) - start);
    return vectorFrom(collection);
  }

  /// Returns exponent depending on vector norm type (for Euclidean norm - 2, Manhattan - 1)
  int _getPowerByNormType(Norm norm) {
    switch(norm) {
      case Norm.euclidean:
        return 2;
      case Norm.manhattan:
        return 1;
      default:
        throw UnsupportedError('Unsupported norm type!');
    }
  }

  /// Returns a SIMD value raised to the integer power
  E _simdToIntPow(E lane, int power) {
    if (power == 0) {
      return createSIMDFilled(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = simdMul(x, x);

    if (power % 2 == 0) {
      return sqrX;
    }

    return simdMul(lane, sqrX);
  }

  /// Returns SIMD list (e.g. Float32x4List) as a result of converting iterable source
  ///
  /// All sequence of [collection] elements splits into groups with [_bucketSize] length
  S convertCollectionToSIMDList(List<double> collection) {
    final numOfBuckets = (collection.length / bucketSize).ceil();
    final source = collection is Float32List
        ? collection
        : createTypedListFromList(collection);
    final target = createSIMDList(numOfBuckets);

    for (int i = 0; i < numOfBuckets; i++) {
      final start = i * bucketSize;
      final end = start + bucketSize;
      final bucketAsList = source.sublist(start, math.min(end, source.length));
      target[i] = createSIMDFromSimpleList(bucketAsList);
    }

    return target;
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a simd value
  MLVector<E> _elementWiseFloatScalarOperation(double scalar, E operation(E a, double b)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], scalar);
    }
    return vectorFromSIMDList(list, length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a simd value
  MLVector<E> _elementWiseSimdScalarOperation(E simdVal, E operation(E a, E b)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], simdVal);
    }
    return vectorFromSIMDList(list, length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a vector (e.g. vector addition)
  MLVector<E> _elementWiseVectorOperation(MLVector<E> vector, E operation(E a, E b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], (vector as MLVectorDataStore<S, E>).data[i]);
    }
    return vectorFromSIMDList(list, length);
  }

  MLVector<E> _elementWiseSelfOperation(E operation(E element)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i]);
    }
    return vectorFromSIMDList(list, length);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising to the integer power
  MLVector<E> _elementWisePow(int exp) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = _simdToIntPow(data[i], exp);
    }
    return vectorFromSIMDList(list, length);
  }

  RangeError _mismatchLengthError() => RangeError('Vectors length must be equal');
}
