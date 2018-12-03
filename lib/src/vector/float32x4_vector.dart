import 'dart:collection';
import 'dart:core';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:linalg/src/vector/norm.dart';
import 'package:linalg/src/mixin/float32/float32_mixin.dart';
import 'package:linalg/src/mixin/data_store/float32x4_data_store_mixin.dart';
import 'package:linalg/src/mixin/float32x4/float32x4_mixin.dart';
import 'package:linalg/src/vector/vector.dart';

/// Vector with SIMD (single instruction, multiple data) architecture support
///
/// An entity, that extends this class, may have potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in a special typed data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of vector operations is provided by SIMD types of Dart language
/// - Each SIMD-typed value is a "cell", that contains several floating point values (2 or 4).
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed with each floating point element
/// simultaneously (in parallel)
class Float32x4Vector extends Object with
    IterableMixin<double>,
    Float32x4Mixin,
    Float32Mixin,
    Float32x4DataStoreMixin implements
        Vector<Float32x4> {

  /// Creates a vector with both empty simd and typed inner lists
  Float32x4Vector(int length) {
    this.length = length;
    data = createSIMDList(length);
  }

  /// Creates a vector from collection
  Float32x4Vector.from(Iterable<double> source) {
    length = source.length;
    final List<double> _source = source is List ? source : source.toList(growable: false);
    data = _convertCollectionToSIMDList(_source);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  Float32x4Vector.fromSIMDList(Float32x4List source, [int origLength]) {
    length = origLength ?? source.length * bucketSize;
    data = Float32x4List.fromList(source.sublist(0, source.length));
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  Float32x4Vector.filled(int length, double value) {
    this.length = length;
    final source = List<double>.filled(length, value);
    data = _convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  Float32x4Vector.zero(int length) {
    this.length = length;
    final source = List<double>.filled(length, 0.0);
    data = _convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  Float32x4Vector.randomFilled(int length, {int seed}) {
    this.length = length;
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    data = _convertCollectionToSIMDList(source);
  }

  int get _bucketsNumber => data.length;

  bool get _isLastBucketNotFull => length % bucketSize > 0;

  Float32x4List get dataWithoutLastBucket =>
      sublist(data, 0, data.length - 1);

  @override
  Float32x4Vector operator +(Object value) {
    if (value is Float32x4Vector) {
      return _elementWiseVectorOperation(value, simdSum);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(createSIMDFilled(value.toDouble()), simdSum);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Float32x4Vector operator -(Object value) {
    if (value is Float32x4Vector) {
      return _elementWiseVectorOperation(value, simdSub);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(createSIMDFilled(value.toDouble()), simdSub);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Float32x4Vector operator *(Object value) {
    if (value is Float32x4Vector) {
      return _elementWiseVectorOperation(value, simdMul);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(value.toDouble(), simdScale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Float32x4Vector operator /(covariant Float32x4Vector vector) =>
      _elementWiseVectorOperation(vector, simdDiv);

  @override
  Float32x4Vector toIntegerPower(int power) => _elementWisePow(power);

  @override
  Float32x4Vector scalarMul(double value) =>
      _elementWiseFloatScalarOperation(value, simdScale);

  @override
  Float32x4Vector scalarDiv(double value) =>
      _elementWiseFloatScalarOperation(1 / value, simdScale);

  @override
  Float32x4Vector scalarAdd(double value) =>
      _elementWiseSimdScalarOperation(createSIMDFilled(value), simdSum);

  @override
  Float32x4Vector scalarSub(double value) =>
      _elementWiseSimdScalarOperation(createSIMDFilled(value), simdSub);

  /// Returns a vector filled with absolute values of an each component of [this] vector
  @override
  Float32x4Vector abs() => _elementWiseSelfOperation(simdAbs);

  @override
  Float32x4Vector copy() => _elementWiseSelfOperation((Float32x4 value) => value);

  @override
  double dot(covariant Float32x4Vector vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => singleSIMDSum(data.reduce(simdSum));

  @override
  double distanceTo(covariant Float32x4Vector vector, [Norm norm = Norm.euclidean]) => (this - vector).norm(norm);

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
  Float32x4Vector query(Iterable<int> indexes) {
    final list = createTypedList(indexes.length);
    int i = 0;
    for (final idx in indexes) {
      list[i++] = this[idx];
    }
    return Float32x4Vector.from(list);
  }

  @override
  Float32x4Vector unique() {
    final unique = <double>[];
    for (int i = 0; i < length; i++) {
      final el = this[i];
      if (!unique.contains(el)) {
        unique.add(el);
      }
    }
    return Float32x4Vector.from(unique);
  }

  @override
  double operator [](int index) {
    if (index >= length) throw RangeError.index(index, this);
    final base = (index / bucketSize).floor();
    final offset = index - base * bucketSize;
    return getScalarByOffsetIndex(data[base], offset);
  }

  @override
  void operator []=(int index, double element) {
    throw UnsupportedError('`[]=` operator is unsupported');
  }

  @override
  Float32x4Vector vectorizedMap(Float32x4 mapper(Float32x4 el)) => _elementWiseSelfOperation(mapper);

  @override
  Float32x4Vector subvector(int start, [int end]) {
    final collection = bufferAsTypedList(
        data.buffer, start, (end > length ? length : end) - start);
    return Float32x4Vector.from(collection);
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
  Float32x4 _simdToIntPow(Float32x4 lane, int power) {
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
  Float32x4List _convertCollectionToSIMDList(List<double> collection) {
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
  Float32x4Vector _elementWiseFloatScalarOperation(double scalar, Float32x4 operation(Float32x4 a, double b)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], scalar);
    }
    return Float32x4Vector.fromSIMDList(list, length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a simd value
  Float32x4Vector _elementWiseSimdScalarOperation(Float32x4 simdVal, Float32x4 operation(Float32x4 a, Float32x4 b)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], simdVal);
    }
    return Float32x4Vector.fromSIMDList(list, length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a vector (e.g. vector addition)
  Float32x4Vector _elementWiseVectorOperation(Float32x4Vector vector, Float32x4 operation(Float32x4 a, Float32x4 b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], vector.data[i]);
    }
    return Float32x4Vector.fromSIMDList(list, length);
  }

  Float32x4Vector _elementWiseSelfOperation(Float32x4 operation(Float32x4 element)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i]);
    }
    return Float32x4Vector.fromSIMDList(list, length);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising to the integer power
  Float32x4Vector _elementWisePow(int exp) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < data.length; i++) {
      list[i] = _simdToIntPow(data[i], exp);
    }
    return Float32x4Vector.fromSIMDList(list, length);
  }

  RangeError _mismatchLengthError() => RangeError('Vectors length must be equal');

  @override
  Iterator<double> get iterator => getIterator(data.buffer, length);
}
