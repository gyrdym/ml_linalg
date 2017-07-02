import 'dart:math' as math;
import 'dart:typed_data';
import 'norm.dart';
import 'vector.dart';

part 'float32_vector.dart';

abstract class _SIMDVector<SIMDVectorType extends _SIMDVector, SIMDListType extends List, TypedListType extends List, SIMDValueType>
    implements Vector<TypedListType> {

  SIMDListType _innerList;
  int _origLength;
  int get _laneLength;

  _SIMDVector(int length) {
    _innerList = _createSIMDList((length / _laneLength).ceil());
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
    SIMDValueType sum = _innerList.reduce((SIMDValueType sum, SIMDValueType item) => _SIMDValuesSum(item, sum));
    return _SIMDValueSum(sum);
  }

  _SIMDVector _abs() {
    SIMDListType list = _createSIMDListFrom(_innerList.map((SIMDValueType item) => _SIMDValueAbs(item))
                                                .toList(growable: false));

    return _createVectorFromTypedList(list, _origLength);
  }

  SIMDValueType _laneIntPow(SIMDValueType lane, int e) {
    if (e == 0) {
      return _createSIMDValueFilled(1.0);
    }

    SIMDValueType x = _laneIntPow(lane, e ~/ 2);
    SIMDValueType sqrX = _SIMDValuesProduct(x, x);

    if (e % 2 == 0) {
      return sqrX;
    }

    return _SIMDValuesProduct(lane, sqrX);
  }

  SIMDListType _convertCollectionToSIMDList(Iterable<double> source) {
    int lanesCount = (source.length / _laneLength).ceil();
    SIMDListType _bufferList = _createSIMDList(lanesCount);

    for (int i = 0; i < lanesCount; i++) {
      int end = (i + 1) * _laneLength;
      int start = end - _laneLength;
      int diff = end - source.length;
      List<double> sublist;

      if (diff > 0) {
        List<double> zeroItems = new List<double>.filled(diff, 0.0);
        sublist = source.toList(growable: false).sublist(start);
        sublist.addAll(zeroItems);
      } else {
        sublist = source.toList(growable: false).sublist(start, end);
      }

      _bufferList[i] = _createSIMDValueFromList(sublist);
    }

    return _bufferList;
  }

  TypedListType _convertSIMDListToTyped(SIMDListType source) {
    List<double> _list = [];

    for (int i = 0; i < source.length - 1; i++) {
      _list.addAll(_SIMDValueToList(source[i]));
    }

    int lengthRemainder = _origLength % _laneLength;
    List<double> remainder = _getPartOfSIMDValueAsList(source.last, lengthRemainder);

    _list.addAll(remainder);

    return _createTypedListFrom(_list);
  }

  SIMDVectorType _elementWiseOperation(Object value, operation(SIMDValueType a, SIMDValueType b)) {
    if (value is SIMDVectorType && value.length != this.length) {
      throw _mismatchLengthError();
    }

    SIMDValueType _scalarValue;

    if (value is SIMDVectorType) {
      //do nothing
    } else if (value is double) {
      _scalarValue = _createSIMDValueFilled(value);
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

  SIMDValueType _createSIMDValueFilled(double value);
  SIMDValueType _createSIMDValueFromList(List<double> list);
  SIMDValueType _SIMDValuesProduct(SIMDValueType a, SIMDValueType b);
  SIMDValueType _SIMDValuesSum(SIMDValueType a, SIMDValueType b);
  SIMDValueType _SIMDValueAbs(SIMDValueType a);
  double _SIMDValueSum(SIMDValueType a);
  List<double> _SIMDValueToList(SIMDValueType a);
  List<double> _getPartOfSIMDValueAsList(SIMDValueType a, int lanesCount);
  SIMDListType _createSIMDList(int length);
  SIMDListType _createSIMDListFrom(List list);
  TypedListType _createTypedListFrom(List<double> list);
  SIMDVectorType _createVectorFromTypedList(SIMDListType list, int length);

  RangeError _mismatchLengthError() => new RangeError('Vectors length must be equal');
}
