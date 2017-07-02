import 'dart:math' as math;
import 'dart:typed_data';
import 'norm.dart';
import 'vector.dart';

part 'float32_vector.dart';

abstract class _SIMDVector<SIMDVectorType extends _SIMDVector, SIMDListType extends List, TypedListType extends List>
    implements Vector<TypedListType> {

  SIMDListType _innerList;
  int _origLength;
  final int _laneLength = 0;

  _SIMDVector(int length) {
    _innerList = _createSIMDList((length / 4).ceil());
    _origLength = length;
  }

  _SIMDVector.from(Iterable<double> source) {
    _origLength = source.length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  _SIMDVector.fromTypedList(SIMDListType source, [int origLength]) {
    _origLength = origLength ?? source.length * _laneLength;
    _innerList = source;
  }

  _SIMDVector.filled(int length, double value) {
    _origLength = length;
    _innerList = _convertCollectionToSIMDList(new List<double>.filled(length, value));
  }

  _SIMDVector.zero(int length) {
    _origLength = length;
    _innerList = _convertCollectionToSIMDList(new List<double>.filled(length, 0.0));
  }

  _SIMDVector.randomFilled(int length, {int seed}) {
    math.Random random = new math.Random(seed);
    List<double> _list = new List<double>.generate(length, (_) => random.nextDouble());
    _origLength = length;
    _innerList = _convertCollectionToSIMDList(_list);
  }

  int get length => _origLength;

  bool operator ==(SIMDVectorType vector) {
    return vector._innerList == _innerList;
  }

  SIMDVectorType operator +(SIMDVectorType vector) => _elementWiseOperation(vector, (a, b) => a + b);

  SIMDVectorType operator -(SIMDVectorType vector) => _elementWiseOperation(vector, (a, b) => a - b);

  SIMDVectorType operator *(SIMDVectorType vector) => _elementWiseOperation(vector, (a, b) => a * b);

  SIMDVectorType operator /(SIMDVectorType vector) => _elementWiseOperation(vector, (a, b) => a / b);

  SIMDVectorType intPow(int exponent) => _elementWisePow(exponent);

  SIMDVectorType scalarMul(double value) => _elementWiseOperation(value, (a, b) => a * b);

  SIMDVectorType scalarDiv(double value) => _elementWiseOperation(value, (a, b) => a / b);

  SIMDVectorType scalarAdd(double value) => _elementWiseOperation(value, (a, b) => a + b);

  SIMDVectorType scalarSub(double value) => _elementWiseOperation(value, (a, b) => a - b);

  double sum() => _summarize();

  SIMDVectorType abs() => _abs();

  SIMDVectorType copy() => _createVectorFromTypedList(_innerList, _origLength);

  double dot(SIMDVectorType vector) => (this * vector).sum();

  double distanceTo(SIMDVectorType vector, [Norm norm = Norm.EUCLIDEAN]) => (this - vector).norm(norm);

  double mean() => sum() / length;

  double norm([Norm norm = Norm.EUCLIDEAN]) {
    int exp = _getExpForNorm(norm);
    return math.pow(intPow(exp).abs().sum(), 1 / exp);
  }

  TypedListType asTypedList() => _convertSIMDListToTyped(_innerList);

  int _getExpForNorm(Norm norm) {
    switch(norm) {
      case Norm.EUCLIDEAN:
        return 2;
      case Norm.MANHATTAN:
        return 1;
      default:
        throw new UnsupportedError('Unsupported norm type!');
    }
  }

  double _summarize() {
    Float32x4 sum = this._innerList.reduce((Float32x4 sum, Float32x4 item) => item + sum);
    return sum.x + sum.y + sum.z + sum.w;
  }

  _SIMDVector _abs() {
    SIMDListType list = _createSIMDListFrom(_innerList.map((Float32x4 item) => item.abs())
                                                .toList(growable: false));

    return _createVectorFromTypedList(list, _origLength);
  }

  Float32x4 _laneIntPow(Float32x4 lane, int e) {
    if (e == 0) {
      return new Float32x4.splat(1.0);
    }

    Float32x4 x = _laneIntPow(lane, e ~/ 2);
    Float32x4 sqrX = x * x;

    if (e % 2 == 0) {
      return sqrX;
    }

    return (lane * sqrX);
  }

  SIMDListType _convertCollectionToSIMDList(Iterable<double> source) {
    int partsCount = (source.length / 4).ceil();
    SIMDListType _bufferList = _createSIMDList(partsCount);

    for (int i = 0; i < partsCount; i++) {
      int end = (i + 1) * 4;
      int start = end - 4;
      int diff = end - source.length;
      List<double> sublist;

      if (diff > 0) {
        List<double> zeroItems = new List<double>.filled(diff, 0.0);
        sublist = source.toList(growable: false).sublist(start);
        sublist.addAll(zeroItems);
      } else {
        sublist = source.toList(growable: false).sublist(start, end);
      }

      double x = sublist[0] ?? 0.0;
      double y = sublist[1] ?? 0.0;
      double z = sublist[2] ?? 0.0;
      double w = sublist[3] ?? 0.0;

      _bufferList[i] = new Float32x4(x, y, z, w);
    }

    return _bufferList;
  }

  TypedListType _convertSIMDListToTyped(SIMDListType source) {
    List<double> _list = [];

    for (int i = 0; i < source.length - 1; i++) {
      Float32x4 item = source[i];
      _list.addAll([item.x, item.y, item.z, item.w]);
    }

    int remainder = _origLength % 4;

    switch (remainder) {
      case 1:
        _list.add(source.last.x);
        break;
      case 2:
        _list.addAll([source.last.x, source.last.y]);
        break;
      case 3:
        _list.addAll([source.last.x, source.last.y, source.last.z]);
        break;
    }

    return _createTypedListFrom(_list);
  }

  SIMDVectorType _elementWiseOperation(Object value, operation(Float32x4 a, Float32x4 b)) {
    if (value is SIMDVectorType && value.length != this.length) {
      throw _mismatchLengthError();
    }

    Float32x4 _scalarValue;

    if (value is SIMDVectorType) {
      //do nothing
    } else if (value is double) {
      _scalarValue = new Float32x4.splat(value);
    } else {
      throw new UnsupportedError('Unsupported operand type (${value.runtimeType})');
    }

    SIMDListType _list = _createSIMDList(this._innerList.length);

    for (int i = 0; i < this._innerList.length; i++) {
      _list[i] = operation(this._innerList[i], value is SIMDVectorType ? value._innerList[i] : _scalarValue);
    }

    return _createVectorFromTypedList(_list, _origLength);
  }

  SIMDVectorType _elementWisePow(int exp) {
    SIMDListType _list = _createSIMDList(_innerList.length);

    for (int i = 0; i < _innerList.length; i++) {
      _list[i] = _laneIntPow(_innerList[i], exp);
    }

    return _createVectorFromTypedList(_list, _origLength);
  }

  SIMDListType _createSIMDList(int length);
  SIMDListType _createSIMDListFrom(List list);
  TypedListType _createTypedListFrom(List<double> list);
  SIMDVectorType _createVectorFromTypedList(SIMDListType list, int length);

  RangeError _mismatchLengthError() => new RangeError('Vectors length must be equal');
}
