import 'dart:math' as math;

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
abstract class SIMDVector<SIMDListType extends List, TypedListType extends List, SIMDValueType>
    implements Vector {

  final SIMDHelper _SIMDHelper;

  /// An efficient SIMD list
  SIMDListType _innerList;

  /// If a [SIMDVector] is created from a list whose length % [_bucketSize] != 0, residual stores here
  SIMDValueType _residualBucket;

  /// A number of vector elements
  int _length;

  int get _bucketsNumber => _innerList.length + (_residualBucket != null ? 1 : 0);

  /// Creates a vector with both empty simd and typed inner lists
  SIMDVector(int length, this._SIMDHelper) {
    _length = length;
    _innerList = _SIMDHelper.createSIMDList(length);
  }

  /// Creates a vector from collection
  SIMDVector.from(Iterable<double> source, this._SIMDHelper) {
    final List<double> _source = source is List ? source : source.toList(growable: false);
    _length = _source.length;
    _innerList = _convertCollectionToSIMDList(_source);
    _residualBucket = _cutResidualBucket(_source);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  SIMDVector.fromSIMDList(SIMDListType source, this._SIMDHelper, [int origLength]) {
    _length = origLength ?? source.length * _SIMDHelper.bucketSize;
    _residualBucket = _cutResidualBucket(source);
    _innerList = _residualBucket == null ? source : source.sublist(0, source.length - 1);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  SIMDVector.filled(int length, double value, this._SIMDHelper) {
    final source = new List<double>.filled(length, value);
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
    _residualBucket = _cutResidualBucket(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  SIMDVector.zero(int length, this._SIMDHelper) {
    final source = new List<double>.filled(length, 0.0);
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
    _residualBucket = _cutResidualBucket(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  SIMDVector.randomFilled(int length, this._SIMDHelper, {int seed}) {
    final random = new math.Random(seed);
    final source = new List<double>.generate(length, (_) => random.nextDouble());
    _length = length;
    _innerList = _convertCollectionToSIMDList(source);
    _residualBucket = _cutResidualBucket(source);
  }

  /// A number of vector elements
  @override
  int get length => _length;

  @override
  SIMDVector operator +(covariant SIMDVector vector) =>
      _elementWiseVectorOperation(vector, (final a, final b) => _SIMDHelper.SIMDSum(a, b));

  @override
  SIMDVector operator -(covariant SIMDVector vector) =>
      _elementWiseVectorOperation(vector, (final a, final b) => _SIMDHelper.SIMDSub(a, b));

  @override
  SIMDVector operator *(covariant SIMDVector vector) =>
      _elementWiseVectorOperation(vector, (final a, final b) => _SIMDHelper.SIMDMul(a, b));

  @override
  SIMDVector operator /(covariant SIMDVector vector) =>
      _elementWiseVectorOperation(vector, (final a, final b) => _SIMDHelper.SIMDDiv(a, b));

  @override
  SIMDVector toIntegerPower(int power) => _elementWisePow(power);

  @override
  SIMDVector scalarMul(double value) =>
      _elementWiseScalarOperation(value, (final a, final b) => _SIMDHelper.SIMDMul(a, b));

  @override
  SIMDVector scalarDiv(double value) =>
      _elementWiseScalarOperation(value, (final a, final b) => _SIMDHelper.SIMDDiv(a, b));

  @override
  SIMDVector scalarAdd(double value) =>
      _elementWiseScalarOperation(value, (final a, final b) => _SIMDHelper.SIMDSum(a, b));

  @override
  SIMDVector scalarSub(double value) =>
      _elementWiseScalarOperation(value, (final a, final b) => _SIMDHelper.SIMDSub(a, b));

  /// Returns a vector filled with absolute values of an each component of [this] vector
  @override
  SIMDVector abs() => _elementWiseSelfOperation((SIMDValueType value) => _SIMDHelper.SIMDAbs(value));

  @override
  SIMDVector copy() => _elementWiseSelfOperation((SIMDValueType value) => value);

  @override
  double dot(covariant SIMDVector vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() {
    final sum = _residualBucket == null
      ? _innerList.reduce((final sum, final item) => _SIMDHelper.SIMDSum(item, sum))
      : _innerList.fold(_residualBucket, (final sum, final item) => _SIMDHelper.SIMDSum(item, sum));
    return _SIMDHelper.singleSIMDSum(sum);
  }

  @override
  double distanceTo(covariant SIMDVector vector, [Norm norm = Norm.euclidean]) => (this - vector).norm(norm);

  @override
  double mean() => sum() / length;

  @override
  double norm([Norm norm = Norm.euclidean]) {
    final power = _getPowerByNormType(norm);
    if (power == 1) {
      return this.abs().sum();
    }
    return math.pow(toIntegerPower(power).sum(), 1 / power);
  }

  @override
  double max() {
    final max = _SIMDHelper.getMaxLane(_innerList.reduce(_SIMDHelper.selectMax));
    if (_residualBucket != null) {
      return _SIMDHelper.SIMDToList(_residualBucket)
          .take(_length % _SIMDHelper.bucketSize)
          .fold(max, (double max, double val) => math.max(max, val));
    } else {
      return max;
    }
  }

  @override
  double min() {
    final min = _SIMDHelper.getMinLane(_innerList.reduce(_SIMDHelper.selectMin));
    if (_residualBucket != null) {
      return _SIMDHelper.SIMDToList(_residualBucket)
          .take(_length % _SIMDHelper.bucketSize)
          .fold(min, (double min, double val) => math.min(min, val));
    } else {
      return min;
    }
  }

  /// Returns exponent depending on vector norm type (for Euclidean norm - 2, Manhattan - 1)
  int _getPowerByNormType(Norm norm) {
    switch(norm) {
      case Norm.euclidean:
        return 2;
      case Norm.manhattan:
        return 1;
      default:
        throw new UnsupportedError('Unsupported norm type!');
    }
  }

  /// Returns a SIMD value raised to the integer power
  SIMDValueType _simdToIntPow(SIMDValueType lane, int power) {
    if (power == 0) {
      return _SIMDHelper.createSIMDFilled(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = _SIMDHelper.SIMDMul(x, x);

    if (power % 2 == 0) {
      return sqrX;
    }

    return _SIMDHelper.SIMDMul(lane, sqrX);
  }

  /// Returns SIMD list (e.g. Float32x4List) as a result of converting iterable source
  ///
  /// All sequence of [collection] elements splits into groups with [_bucketSize] length
  SIMDListType _convertCollectionToSIMDList(Iterable<double> collection) {
    final numOfBuckets = collection.length ~/ _SIMDHelper.bucketSize;
    final TypedListType source = collection is TypedListType
      ? collection
      : _SIMDHelper.createTypedListFromList(collection);
    final target = _SIMDHelper.createSIMDList(numOfBuckets);

    for (int i = 0; i < numOfBuckets; i++) {
      final start = i * _SIMDHelper.bucketSize;
      final end = start + _SIMDHelper.bucketSize;
      final bucketAsList = source.sublist(start, end);
      target[i] = _SIMDHelper.createSIMDFromSimpleList(bucketAsList);
    }

    return target;
  }

  SIMDValueType _cutResidualBucket(List collection) {
    if (collection is SIMDListType) {
      if (collection.length % _SIMDHelper.bucketSize > 0) {
        return collection.last;
      } else {
        return null;
      }
    }

    final length = collection.length;
    final numOfBuckets = length ~/ _SIMDHelper.bucketSize;
    final exceeded = length % _SIMDHelper.bucketSize;
    final residue = new List<double>
        .generate(exceeded, (int idx) => collection[numOfBuckets * _SIMDHelper.bucketSize + idx]);
    return _SIMDHelper.createSIMDFromSimpleList(residue);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a scalar (e.g. vector addition)
  SIMDVector _elementWiseScalarOperation(double value, SIMDValueType operation(SIMDValueType a, SIMDValueType b)) {
    final scalar = _SIMDHelper.createSIMDFilled(value);
    final list = _SIMDHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i], scalar);
    }
    if (this._residualBucket != null) {
      list[list.length - 1] = operation(_residualBucket, scalar);
    }
    return _SIMDHelper.createVectorFromSIMDList(list, _length);
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation with a vector (e.g. vector addition)
  SIMDVector _elementWiseVectorOperation(SIMDVector vector, SIMDValueType operation(SIMDValueType a, SIMDValueType b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = _SIMDHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i], vector._innerList[i]);
    }
    if (_residualBucket != null) {
      list[list.length - 1] = operation(_residualBucket, vector._residualBucket);
    }
    return _SIMDHelper.createVectorFromSIMDList(list, _length);
  }

  SIMDVector _elementWiseSelfOperation(SIMDValueType operation(SIMDValueType a)) {
    final list = _SIMDHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = operation(_innerList[i]);
    }
    if (_residualBucket != null) {
      list[list.length - 1] = operation(_residualBucket);
    }
    return _SIMDHelper.createVectorFromSIMDList(list, _length);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising to the integer power
  SIMDVector _elementWisePow(int exp) {
    final list = _SIMDHelper.createSIMDList(_bucketsNumber);
    for (int i = 0; i < _innerList.length; i++) {
      list[i] = _simdToIntPow(_innerList[i], exp);
    }
    if (_residualBucket != null) {
      list[list.length - 1] = _simdToIntPow(_residualBucket, exp);
    }
    return _SIMDHelper.createVectorFromSIMDList(list, _length);
  }

  SIMDVector query(Iterable<int> indexes) {
    final list = _SIMDHelper.createTypedList(indexes.length);
    int i = 0;
    for (final idx in indexes) {
      list[i++] = this[idx];
    }
    return _SIMDHelper.createVectorFromList(list);
  }

  SIMDVector unique() {
    final unique = <double>[];
    for (int i = 0; i < _length; i++) {
      final el = this[i];
      if (!unique.contains(el)) {
        unique.add(el);
      }
    }
    return _SIMDHelper.createVectorFromList(unique);
  }

  double operator [](int index) {
    if (index >= _length) throw new RangeError.index(index, this);
    final base = (index / _SIMDHelper.bucketSize).floor();
    final offset = index - base * _SIMDHelper.bucketSize;
    if (index >= _innerList.length * _SIMDHelper.bucketSize) {
      return _SIMDHelper.getScalarByOffsetIndex(_residualBucket, offset);
    }
    return _SIMDHelper.getScalarByOffsetIndex(_innerList[base], offset);
  }

  void operator []=(int index, double element) {
    throw new UnsupportedError('`[]=` operator is unsupported');
  }

  @override
  List<double> toList() => new List<double>.generate(_length, (int idx) => this[idx]);

  RangeError _mismatchLengthError() => new RangeError('Vectors length must be equal');
}
