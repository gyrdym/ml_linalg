import 'dart:math' as math;
import 'dart:typed_data';

import 'package:linalg/src/norm.dart';
import 'package:linalg/src/simd/simd_helper.dart';
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
class SIMDVector<S extends List<E>, T extends List<double>, E> implements Vector<E> {

  final SIMDHelper<S, T, E> _simdHelper;

  /// An efficient SIMD list
  S _innerList;

  /// A number of vector elements
  int _length;

  /// Creates a vector with both empty simd and typed inner lists
  SIMDVector(int length, this._simdHelper) {
    _length = length;
    _innerList = _simdHelper.createSIMDList(length);
  }

  /// Creates a vector from collection
  SIMDVector.from(Iterable<double> source, this._simdHelper) {
    final List<double> _source = source is List ? source : source.toList(growable: false);
    _length = _source.length;
    _innerList = _convertCollectionToSIMDList(_source);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  SIMDVector.fromSIMDList(S source, this._simdHelper, [int origLength]) {
    _length = origLength ?? source.length * _simdHelper.bucketSize;
    _innerList = source.sublist(0, source.length) as S;
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  SIMDVector.filled(int length, double value, this._simdHelper) {
    final source = List<double>.filled(length, value);
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  SIMDVector.zero(int length, this._simdHelper) {
    final source = List<double>.filled(length, 0.0);
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  SIMDVector.randomFilled(int length, this._simdHelper, {int seed}) {
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  int get _bucketsNumber => _innerList.length;

  bool get _isLastBucketNotFull => _innerList.length % _simdHelper.bucketSize > 0;

  /// A number of vector elements
  @override
  int get length => _length;

  @override
  SIMDVector<S, T, E> operator +(covariant SIMDVector<S, T, E> vector) =>
      _elementWiseVectorOperation(vector, _simdHelper.simdSum);

  @override
  SIMDVector<S, T, E> operator -(covariant SIMDVector<S, T, E> vector) =>
      _elementWiseVectorOperation(vector, _simdHelper.simdSub);

  @override
  SIMDVector<S, T, E> operator *(covariant SIMDVector<S, T, E> vector) =>
      _elementWiseVectorOperation(vector, _simdHelper.simdMul);

  @override
  SIMDVector<S, T, E> operator /(covariant SIMDVector<S, T, E> vector) =>
      _elementWiseVectorOperation(vector, _simdHelper.simdDiv);

  @override
  SIMDVector<S, T, E> toIntegerPower(int power) => _elementWisePow(power);

  @override
  SIMDVector<S, T, E> scalarMul(double value) =>
      _elementWiseScalarOperation(value, _simdHelper.simdMul);

  @override
  SIMDVector<S, T, E> scalarDiv(double value) =>
      _elementWiseScalarOperation(value, _simdHelper.simdDiv);

  @override
  SIMDVector<S, T, E> scalarAdd(double value) =>
      _elementWiseScalarOperation(value, _simdHelper.simdSum);

  @override
  SIMDVector<S, T, E> scalarSub(double value) =>
      _elementWiseScalarOperation(value, _simdHelper.simdSub);

  /// Returns a vector filled with absolute values of an each component of [this] vector
  @override
  SIMDVector<S, T, E> abs() => _elementWiseSelfOperation(_simdHelper.simdAbs);

  @override
  SIMDVector<S, T, E> copy() => _elementWiseSelfOperation((E value) => value);

  @override
  double dot(covariant SIMDVector<S, T, E> vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => _simdHelper.singleSIMDSum(_innerList.reduce(_simdHelper.simdSum));

  @override
  double distanceTo(covariant SIMDVector<S, T, E> vector, [Norm norm = Norm.euclidean]) => (this - vector).norm(norm);

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
  double max() => _simdHelper.getMaxLane(_innerList.reduce(_simdHelper.selectMax));

  @override
  double min() {
    if (_isLastBucketNotFull) {
      final listWithoutLastBucket = _simdHelper.sublist(_innerList, 0, _innerList.length - 1);
      final min = _simdHelper.getMinLane(listWithoutLastBucket.reduce(_simdHelper.selectMin));
      return _simdHelper.simdToList(_innerList.last)
          .take(_length % _simdHelper.bucketSize)
          .fold(min, math.min);
    } else {
      return _simdHelper.getMinLane(_innerList.reduce(_simdHelper.selectMin));
    }
  }

  @override
  SIMDVector<S, T, E> query(Iterable<int> indexes) {
    final list = _simdHelper.createTypedList(indexes.length);
    int i = 0;
    for (final idx in indexes) {
      list[i++] = this[idx];
    }
    return SIMDVector<S, T, E>.from(list, _simdHelper);
  }

  @override
  SIMDVector<S, T, E> unique() {
    final unique = <double>[];
    for (int i = 0; i < _length; i++) {
      final el = this[i];
      if (!unique.contains(el)) {
        unique.add(el);
      }
    }
    return SIMDVector<S, T, E>.from(unique, _simdHelper);
  }

  @override
  double operator [](int index) {
    if (index >= _length) throw RangeError.index(index, this);
    final base = (index / _simdHelper.bucketSize).floor();
    final offset = index - base * _simdHelper.bucketSize;
    return _simdHelper.getScalarByOffsetIndex(_innerList[base], offset);
  }

  @override
  void operator []=(int index, double element) {
    throw UnsupportedError('`[]=` operator is unsupported');
  }

  @override
  List<double> toList() => List<double>.generate(_length, (int idx) => this[idx]);

  @override
  SIMDVector<S, T, E> vectorizedMap(E mapper(E el)) => _elementWiseSelfOperation(mapper);

  SIMDVector<S, T, E> subVector(int start, [int end]) {
    final protrusion = ((end ?? _length) - _innerList.length * _simdHelper.bucketSize)
        .abs();
    final byteData = (_innerList as TypedData)
        .buffer
        .asByteData(start * 8, (protrusion > 0 ? _length : end) - start);
    final residualBucket = (protrusion > 0)
        ? _simdHelper.takeFirstNLanes(_innerList.last, protrusion)
        : null;

    final collection = _simdHelper.createTypedListFromByteBuffer(byteData.buffer, residualBucket);
    return SIMDVector.from(collection, _simdHelper);
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
      return _simdHelper.createSIMDFilled(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = _simdHelper.simdMul(x, x);

    if (power % 2 == 0) {
      return sqrX;
    }

    return _simdHelper.simdMul(lane, sqrX);
  }

  /// Returns SIMD list (e.g. Float32x4List) as a result of converting iterable source
  ///
  /// All sequence of [collection] elements splits into groups with [_bucketSize] length
  S _convertCollectionToSIMDList(List<double> collection) {
    final numOfBuckets = (collection.length / _simdHelper.bucketSize).ceil();
    final T source = collection is T
      ? collection
      : _simdHelper.createTypedListFromList(collection);
    final S target = _simdHelper.createSIMDList(numOfBuckets);

    for (int i = 0; i < numOfBuckets; i++) {
      final start = i * _simdHelper.bucketSize;
      final end = start + _simdHelper.bucketSize;
      final bucketAsList = source.sublist(start, math.min(end, source.length));
      target[i] = _simdHelper.createSIMDFromSimpleList(bucketAsList);
    }

    return target;
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a scalar (e.g. vector addition)
  SIMDVector<S, T, E> _elementWiseScalarOperation(double value, E operation(E a, E b)) {
    final scalar = _simdHelper.createSIMDFilled(value);
    final list = _simdHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i], scalar);
    }
    return SIMDVector.fromSIMDList(list, _simdHelper, _length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a vector (e.g. vector addition)
  SIMDVector<S, T, E> _elementWiseVectorOperation(SIMDVector vector, E operation(E a, E b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = _simdHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i], vector._innerList[i] as E);
    }
    return SIMDVector.fromSIMDList(list, _simdHelper, _length);
  }

  SIMDVector<S, T, E> _elementWiseSelfOperation(E operation(E element)) {
    final list = _simdHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i]);
    }
    return SIMDVector.fromSIMDList(list, _simdHelper, _length);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising to the integer power
  SIMDVector<S, T, E> _elementWisePow(int exp) {
    final list = _simdHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = _simdToIntPow(_innerList[i], exp);
    }
    return SIMDVector.fromSIMDList(list, _simdHelper, _length);
  }

  RangeError _mismatchLengthError() => RangeError('Vectors length must be equal');
}
