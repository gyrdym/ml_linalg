import 'dart:math' as math;
import 'dart:typed_data';
import 'norm.dart';
import 'vector.dart';

class Float32x4Vector implements Vector {
  Float32x4List _innerList;
  int _origLength;

  Float32x4Vector(int length) {
    _innerList = new Float32x4List((length / 4).ceil());
    _origLength = length;
  }

  Float32x4Vector.from(Iterable<double> source) {
    _origLength = source.length;
    _innerList = _convertCollectionToSIMDList(source);
  }

  Float32x4Vector.fromTypedList(Float32x4List source, [int origLength]) {
    _origLength = origLength ?? source.length * 4;
    _innerList = source;
  }

  Float32x4Vector.filled(int length, double value) {
    _origLength = length;
    _innerList = _convertCollectionToSIMDList(new List<double>.filled(length, value));
  }

  Float32x4Vector.zero(int length) {
    _origLength = length;
    _innerList = _convertCollectionToSIMDList(new List<double>.filled(length, 0.0));
  }

  Float32x4Vector.randomFilled(int length, {int seed}) {
    math.Random random = new math.Random(seed);
    List<double> _list = new List<double>.generate(length, (_) => random.nextDouble());
    _origLength = length;
    _innerList = _convertCollectionToSIMDList(_list);
  }

  int get length => _origLength;

  bool operator ==(Float32x4Vector vector) {
    return vector._innerList == _innerList;
  }

  Float32x4Vector operator +(Float32x4Vector vector) => _elementWiseOperation(vector, (a, b) => a + b);

  Float32x4Vector operator -(Float32x4Vector vector) => _elementWiseOperation(vector, (a, b) => a - b);

  Float32x4Vector operator *(Float32x4Vector vector) => _elementWiseOperation(vector, (a, b) => a * b);

  Float32x4Vector operator /(Float32x4Vector vector) => _elementWiseOperation(vector, (a, b) => a / b);

  Float32x4Vector intPow(int exponent) => _elementWisePow(exponent);

  Float32x4Vector scalarMul(double value) => _elementWiseOperation(value, (a, b) => a * b);

  Float32x4Vector scalarDiv(double value) => _elementWiseOperation(value, (a, b) => a / b);

  Float32x4Vector scalarAdd(double value) => _elementWiseOperation(value, (a, b) => a + b);

  Float32x4Vector scalarSub(double value) => _elementWiseOperation(value, (a, b) => a - b);

  double sum() => _summarize();

  Float32x4Vector abs() => _abs();

  Float32x4Vector copy() => new Float32x4Vector.fromTypedList(_innerList, _origLength);

  double dot(Float32x4Vector vector) => (this * vector).sum();

  double distanceTo(Float32x4Vector vector, [Norm norm = Norm.EUCLIDEAN]) => (this - vector).norm(norm);

  double mean() => sum() / length;

  double norm([Norm norm = Norm.EUCLIDEAN]) {
    int exp = _getExpForNorm(norm);
    return math.pow(intPow(exp).abs().sum(), 1 / exp);
  }

  Float32List asTypedList() => _convertSIMDListToTyped(_innerList);

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

  Float32x4Vector _abs() {
    Float32x4List list = new Float32x4List.fromList(
        _innerList.map((Float32x4 item) => item.abs())
            .toList(growable: false));

    return new Float32x4Vector.fromTypedList(list, _origLength);
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

  Float32x4List _convertCollectionToSIMDList(Iterable<double> source) {
    int partsCount = (source.length / 4).ceil();
    Float32x4List _bufferList = new Float32x4List(partsCount);

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

  Float32List _convertSIMDListToTyped(Float32x4List source) {
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

    return new Float32List.fromList(_list);
  }

  Float32x4Vector _elementWiseOperation(Object value, operation(Float32x4 a, Float32x4 b)) {
    if (value is Float32x4Vector && value.length != this.length) {
      throw _mismatchLengthError();
    }

    Float32x4 _scalarValue;

    if (value is Float32x4Vector) {
      //do nothing
    } else if (value is double) {
      _scalarValue = new Float32x4.splat(value);
    } else {
      throw new UnsupportedError('Unsupported operand type (${value.runtimeType})');
    }

    Float32x4List _list = new Float32x4List(this._innerList.length);

    for (int i = 0; i < this._innerList.length; i++) {
      _list[i] = operation(this._innerList[i], value is Float32x4Vector ? value._innerList[i] : _scalarValue);
    }

    return new Float32x4Vector.fromTypedList(_list, _origLength);
  }

  Float32x4Vector _elementWisePow(int exp) {
    Float32x4List _list = new Float32x4List(_innerList.length);

    for (int i = 0; i < _innerList.length; i++) {
      _list[i] = _laneIntPow(_innerList[i], exp);
    }

    return new Float32x4Vector.fromTypedList(_list, _origLength);
  }

  RangeError _mismatchLengthError() => new RangeError('Vectors length must be equal');
}
