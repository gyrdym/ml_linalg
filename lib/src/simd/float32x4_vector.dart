import 'dart:core';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:linalg/src/norm.dart';
import 'package:linalg/src/simd/float32x4_mixin.dart';
import 'package:linalg/src/vector.dart';

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
class Float32x4Vector extends Object with Float32x4Mixin implements Vector<Float32x4>, Iterable<double> {

  /// An efficient SIMD list
  Float32x4List _innerList;

  /// A number of vector elements
  int _length;

  /// Creates a vector with both empty simd and typed inner lists
  Float32x4Vector(int length) {
    _length = length;
    _innerList = createSIMDList(length);
  }

  /// Creates a vector from collection
  Float32x4Vector.from(Iterable<double> source) {
    final List<double> _source = source is List ? source : source.toList(growable: false);
    _length = _source.length;
    _innerList = _convertCollectionToSIMDList(_source);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  Float32x4Vector.fromSIMDList(Float32x4List source, [int origLength]) {
    _length = origLength ?? source.length * bucketSize;
    _innerList = Float32x4List.fromList(source.sublist(0, source.length));
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  Float32x4Vector.filled(int length, double value) {
    final source = List<double>.filled(length, value);
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  Float32x4Vector.zero(int length) {
    final source = List<double>.filled(length, 0.0);
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  Float32x4Vector.randomFilled(int length, {int seed}) {
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  int get _bucketsNumber => _innerList.length;

  bool get _isLastBucketNotFull => _length % bucketSize > 0;

  Float32x4List get _innerListWithoutLastBucket =>
      sublist(_innerList, 0, _innerList.length - 1);

  /// A number of vector elements
  @override
  int get length => _length;

  @override
  Float32x4Vector operator +(covariant Float32x4Vector vector) =>
      _elementWiseVectorOperation(vector, simdSum);

  @override
  Float32x4Vector operator -(covariant Float32x4Vector vector) =>
      _elementWiseVectorOperation(vector, simdSub);

  @override
  Float32x4Vector operator *(covariant Float32x4Vector vector) =>
      _elementWiseVectorOperation(vector, simdMul);

  @override
  Float32x4Vector operator /(covariant Float32x4Vector vector) =>
      _elementWiseVectorOperation(vector, simdDiv);

  @override
  Float32x4Vector toIntegerPower(int power) => _elementWisePow(power);

  @override
  Float32x4Vector scalarMul(double value) =>
      _elementWiseScalarOperation(value, simdMul);

  @override
  Float32x4Vector scalarDiv(double value) =>
      _elementWiseScalarOperation(value, simdDiv);

  @override
  Float32x4Vector scalarAdd(double value) =>
      _elementWiseScalarOperation(value, simdSum);

  @override
  Float32x4Vector scalarSub(double value) =>
      _elementWiseScalarOperation(value, simdSub);

  /// Returns a vector filled with absolute values of an each component of [this] vector
  @override
  Float32x4Vector abs() => _elementWiseSelfOperation(simdAbs);

  @override
  Float32x4Vector copy() => _elementWiseSelfOperation((Float32x4 value) => value);

  @override
  double dot(covariant Float32x4Vector vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => singleSIMDSum(_innerList.reduce(simdSum));

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
      final listOnlyWithFullBuckets = _innerListWithoutLastBucket;
      if (listOnlyWithFullBuckets.isNotEmpty) {
        max = getMaxLane(listOnlyWithFullBuckets.reduce(selectMax));
      }
      return simdToList(_innerList.last)
          .take(_length % bucketSize)
          .fold(max, math.max);
    } else {
      return getMaxLane(_innerList.reduce(selectMax));
    }
  }

  @override
  double min() {
    if (_isLastBucketNotFull) {
      var min = double.infinity;
      final listOnlyWithFullBuckets = _innerListWithoutLastBucket;
      if (listOnlyWithFullBuckets.isNotEmpty) {
        min = getMinLane(listOnlyWithFullBuckets.reduce(selectMin));
      }
      return simdToList(_innerList.last)
          .take(_length % bucketSize)
          .fold(min, math.min);
    } else {
      return getMinLane(_innerList.reduce(selectMin));
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
    for (int i = 0; i < _length; i++) {
      final el = this[i];
      if (!unique.contains(el)) {
        unique.add(el);
      }
    }
    return Float32x4Vector.from(unique);
  }

  @override
  double operator [](int index) {
    if (index >= _length) throw RangeError.index(index, this);
    final base = (index / bucketSize).floor();
    final offset = index - base * bucketSize;
    return getScalarByOffsetIndex(_innerList[base], offset);
  }

  @override
  void operator []=(int index, double element) {
    throw UnsupportedError('`[]=` operator is unsupported');
  }

  @override
  List<double> toList({bool growable = false}) => List<double>.generate(_length, (int idx) => this[idx]);

  @override
  Float32x4Vector vectorizedMap(Float32x4 mapper(Float32x4 el)) => _elementWiseSelfOperation(mapper);

  Float32x4Vector subVector(int start, [int end]) {
    final collection = bufferAsTypedList(
        _innerList.buffer, start, (end > _length ? _length : end) - start);
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

  /// Returns a vector as a result of applying to [this] any element-wise operation with a scalar (e.g. vector addition)
  Float32x4Vector _elementWiseScalarOperation(double value, Float32x4 operation(Float32x4 a, Float32x4 b)) {
    final scalar = createSIMDFilled(value);
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i], scalar);
    }
    return Float32x4Vector.fromSIMDList(list, _length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a vector (e.g. vector addition)
  Float32x4Vector _elementWiseVectorOperation(Float32x4Vector vector, Float32x4 operation(Float32x4 a, Float32x4 b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i], vector._innerList[i]);
    }
    return Float32x4Vector.fromSIMDList(list, _length);
  }

  Float32x4Vector _elementWiseSelfOperation(Float32x4 operation(Float32x4 element)) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i]);
    }
    return Float32x4Vector.fromSIMDList(list, _length);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising to the integer power
  Float32x4Vector _elementWisePow(int exp) {
    final list = createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = _simdToIntPow(_innerList[i], exp);
    }
    return Float32x4Vector.fromSIMDList(list, _length);
  }

  RangeError _mismatchLengthError() => RangeError('Vectors length must be equal');

  @override
  bool any(bool Function(double element) test) => toList().any(test);

  @override
  Iterable<R> cast<R>() => toList().cast<R>();

  @override
  bool contains(Object element) => toList().contains(element);

  @override
  double elementAt(int index) => toList().elementAt(index);

  @override
  bool every(bool Function(double element) test) => toList().every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(double element) f) => toList().expand<T>(f);

  @override
  double get first => toList().first;

  @override
  double firstWhere(bool Function(double element) test, {double Function() orElse}) => toList().firstWhere(test);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, double element) combine) =>
      toList().fold<T>(initialValue, combine);

  @override
  Iterable<double> followedBy(Iterable<double> other) => toList().followedBy(other);

  @override
  void forEach(void Function(double element) f) => toList().forEach(f);

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length > 0;

  @override
  Iterator<double> get iterator => toList().iterator;

  @override
  String join([String separator = '']) => toList().join(separator);

  @override
  double get last => toList().last;

  @override
  double lastWhere(bool Function(double element) test, {double Function() orElse}) =>
      toList().lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(double e) f) => toList().map<T>(f);

  @override
  double reduce(double Function(double value, double element) combine) => toList().reduce(combine);

  @override
  double get single => toList().single;

  @override
  double singleWhere(bool Function(double element) test, {double Function() orElse}) =>
      toList().singleWhere(test, orElse: orElse);

  @override
  Iterable<double> skip(int count) => toList().skip(count);

  @override
  Iterable<double> skipWhile(bool Function(double value) test) => toList().skipWhile(test);

  @override
  Iterable<double> take(int count) => toList().take(count);

  @override
  Iterable<double> takeWhile(bool Function(double value) test) => toList().takeWhile(test);

  @override
  Set<double> toSet() => toList().toSet();

  @override
  Iterable<double> where(bool Function(double element) test) => toList().where(test);

  @override
  Iterable<T> whereType<T>() => toList().whereType<T>();
}
