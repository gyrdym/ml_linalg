import 'dart:math' as math;
import 'dart:typed_data';
import 'norm.dart';
import 'vector.dart';

part 'float32x4_vector.dart';
part 'float64x2_vector.dart';

/// A vector with SIMD (single instruction, multiple data) architecture support
///
/// An entity, that extends this class, may has potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in special typed data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of vector operations is provided by SIMD types of dart language
/// - Each SIMD-typed value is a "cell", that contains several floating point values (at the present moment - 2 or 4).
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed on an each floating point element
/// simultaneously (in parallel)
abstract class _SIMDVector<SIMDVectorType extends _SIMDVector, SIMDListType extends List, TypedListType extends List, SIMDValueType>
    implements Vector, List<double> {

  TypedListType _typedList;

  /// An efficient SIMD list
  SIMDListType _simdList;

  /// A number of vector elements
  int _length;

  /// Computation lane width (lane supports 2 or 4 elements to be processed simultaneously, this characteristic
  /// restricted by computing platform architecture)
  int get _laneSize;

  /// Creates a vector from collection
  _SIMDVector.from(Iterable<double> source) {
    _length = source.length;
    _typedList = _createTypedListFrom(source);
    _simdList = _convertCollectionToSIMDList(_typedList);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  _SIMDVector.fromSIMDList(SIMDListType source, [int origLength]) {
    _length = origLength ?? source.length * _laneSize;
    _typedList = _convertSIMDListToTyped(source);
    _simdList = source;
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  _SIMDVector.filled(int length, double value) {
    _length = length;
    // @TODO: make a factory-method for filled typed list
    _typedList = _createTypedListFrom(new List<double>.filled(length, value));
    _simdList = _convertCollectionToSIMDList(_typedList);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  _SIMDVector.zero(int length) {
    _length = length;
    // @TODO: make a factory-method for filled typed list
    _typedList = _createTypedListFrom(new List<double>.filled(length, 0.0));
    _simdList = _convertCollectionToSIMDList(_typedList);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  _SIMDVector.randomFilled(int length, {int seed}) {
    final random = new math.Random(seed);
    final source = new List<double>.generate(length, (_) => random.nextDouble());
    _length = length;
    _typedList = _createTypedListFrom(source);
    _simdList = _convertCollectionToSIMDList(_typedList);
  }

  /// A number of vector elements
  int get length => _length;

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

  SIMDVectorType copy() => _createVectorFromSIMDList(_simdList, _length);

  double dot(SIMDVectorType vector) => (this * vector).sum();

  double distanceTo(SIMDVectorType vector, [Norm norm = Norm.EUCLIDEAN]) => (this - vector).norm(norm);

  double mean() => sum() / length;

  double norm([Norm norm = Norm.EUCLIDEAN]) {
    int exp = _getExpForNorm(norm);
    return math.pow(intPow(exp).abs().sum(), 1 / exp);
  }

  /// Returns exponent depending on vector norm type (for Euclidean norm - 2, Manhattan - 1)
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

  /// Returns sum of all vector components
  double _summarize() {
    SIMDValueType sum = _simdList.reduce((SIMDValueType sum, SIMDValueType item) => _SIMDValuesSum(item, sum));
    return _SIMDValueSum(sum);
  }

  /// Returns a vector filled with absolute values of an each component of [this] vector
  _SIMDVector _abs() {
    SIMDListType list = _createSIMDListFrom(_simdList.map((SIMDValueType item) => _SIMDValueAbs(item))
                                                .toList(growable: false));

    return _createVectorFromSIMDList(list, _length);
  }

  /// Returns lane (a single SIMD value) raised to the integer power
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

  /// Returns SIMD list (e.g. Float32x4List) as a result of converting iterable source
  ///
  /// All sequence of [collection] elements splits into groups with [_laneSize] length
  SIMDListType _convertCollectionToSIMDList(Iterable<double> collection) {
    final lanesNumber = (collection.length / _laneSize).ceil();
    final targetList = _createSIMDList(lanesNumber);
    final efficientSource = collection is TypedListType ?
      (collection as TypedListType) : _createTypedListFrom(collection);

    for (int i = 0; i < lanesNumber; i++) {
      final laneLimitIndex = (i + 1) * _laneSize;
      final laneStartIndex = laneLimitIndex - _laneSize;
      final residual = efficientSource.length - laneLimitIndex;
      final laneAsSimpleList = (residual < 0) ?
        ([]
          ..addAll(efficientSource.sublist(laneStartIndex))
          ..addAll(new List<double>.filled(-residual, 0.0))
          ..length = _laneSize
        )
      : efficientSource.sublist(laneStartIndex, laneLimitIndex);

      targetList[i] = _createSIMDValueFromSimpleList(laneAsSimpleList);
    }

    return targetList;
  }

  /// Returns special typed list (e.g. Float32List) as a result of converting SIMD [source]
  TypedListType _convertSIMDListToTyped(SIMDListType source) {
    final _list = _createTypedList(_length);

    for (int laneIdx = 0; laneIdx < source.length; laneIdx++) {
      final laneAsList = _SIMDValueToList(source[laneIdx]);
      for (int lanePartIdx = 0; lanePartIdx < laneAsList.length; lanePartIdx++) {
        final actualIdx = laneIdx * _laneSize + lanePartIdx;
        if (actualIdx == _length) {
          break;
        }
        _list[actualIdx] = laneAsList[lanePartIdx];
      }
    }

    return _list;
  }

  /// Returns a vector as a result of applying to [this] any element-wise operation (e.g. vector addition)
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

    final _list = _createSIMDList(this._simdList.length);

    for (int i = 0; i < this._simdList.length; i++) {
      _list[i] = operation(this._simdList[i], value is SIMDVectorType ? value._simdList[i] : _scalarValue);
    }

    return _createVectorFromSIMDList(_list, _length);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising to the integer power
  SIMDVectorType _elementWisePow(int exp) {
    final _list = _createSIMDList(_simdList.length);

    for (int i = 0; i < _simdList.length; i++) {
      _list[i] = _laneIntPow(_simdList[i], exp);
    }

    return _createVectorFromSIMDList(_list, _length);
  }

  // Factory methods are below
  SIMDValueType _createSIMDValueFilled(double value);
  SIMDValueType _createSIMDValueFromSimpleList(List<double> list);
  SIMDValueType _SIMDValuesProduct(SIMDValueType a, SIMDValueType b);
  SIMDValueType _SIMDValuesSum(SIMDValueType a, SIMDValueType b);
  SIMDValueType _SIMDValueAbs(SIMDValueType a);
  double _SIMDValueSum(SIMDValueType a);
  List<double> _SIMDValueToList(SIMDValueType a);
  SIMDListType _createSIMDList(int length);
  SIMDListType _createSIMDListFrom(List list);
  TypedListType _createTypedList(int length);
  TypedListType _createTypedListFrom(List<double> list);
  SIMDVectorType _createVectorFromSIMDList(SIMDListType list, int length);

  RangeError _mismatchLengthError() => new RangeError('Vectors length must be equal');

  // `List` interface implementation
  @override
  double operator [](int index) => _typedList[index];

  @override
  void operator []=(int index, double element) {
    throw new UnsupportedError('');
  }

  @override
  Iterable<double> get reversed => _typedList.reversed;

  @override
  void set length(int value) {
    throw new UnsupportedError('');
  }

  @override
  void add(double value) {
    throw new UnsupportedError('add');
  }

  @override
  void addAll(Iterable<double> collection) {
    throw new UnsupportedError('');
  }

  @override
  Map<int, dynamic> asMap() => _typedList.asMap();

  @override
  void clear() {
    throw new UnsupportedError('');
  }

  @override
  void fillRange(int start, int end, [double fillValue]) {
    throw new UnsupportedError('');
  }

  @override
  Iterable<double> getRange(int start, int end) => _typedList.getRange(start, end);

  @override
  int indexOf(double element, [int start = 0]) => _typedList.indexOf(element);

  @override
  void insert(int index, double element) {
    throw new UnsupportedError('');
  }

  @override
  void insertAll(int index, Iterable<double> iterable) {
    throw new UnsupportedError('');
  }

  @override
  int lastIndexOf(double element, [int start]) => _typedList.lastIndexOf(element, start);

  @override
  bool remove(double element) {
    throw new UnsupportedError('');
  }

  @override
  double removeAt(int index) {
    throw new UnsupportedError('');
  }

  @override
  double removeLast() {
    throw new UnsupportedError('');
  }

  @override
  void removeRange(int start, int end) {
    throw new UnsupportedError('');
  }

  @override
  void removeWhere(Function test) {
    throw new UnsupportedError('');
  }

  @override
  void replaceRange(int start, int end, Iterable<double> replacement) {
    throw new UnsupportedError('');
  }

  @override
  void retainWhere(Function test) {
    throw new UnsupportedError('');
  }

  @override
  void setAll(int index, Iterable<double> iterable) {
    throw new UnsupportedError('');
  }

  @override
  void setRange(int start, int end, Iterable<double> iterable, [int skipCount]) {
    throw new UnsupportedError('');
  }

  @override
  void shuffle([math.Random random]) {
    throw new UnsupportedError('');
  }

  @override
  void sort([Function sorter]) {
    throw new UnsupportedError('');
  }

  @override
  Iterable<double> sublist(int start, [int double]) => _typedList.sublist(start, double);

  // `Iterable` interface implementation

  @override
  double get first => _simdList.first;

  @override
  bool get isEmpty => _simdList.isEmpty;

  @override
  bool get isNotEmpty => _simdList.isNotEmpty;

  @override
  Iterator<double> get iterator => _typedList.iterator;

  @override
  double get last => _typedList.last;

  @override
  double get single => _typedList.single;

  @override
  bool any(Function test) => _typedList.any(test);

  @override
  bool contains(double value) => _typedList.contains(value);

  @override
  double elementAt(int position) => _typedList.elementAt(position);

  @override
  bool every(Function test) => _typedList.every(test);

  @override
  Iterable<double> expand<double>(Function expander) => _typedList.expand(expander);

  @override
  double firstWhere(Function test, {Function orElse}) => _typedList.firstWhere(test, orElse: orElse);

  @override
  double fold<double>(double initialValue, Function combine) => _typedList.fold(initialValue, combine);

  @override
  void forEach(Function callback) => _typedList.forEach(callback);

  @override
  String join([String separator]) => _typedList.join(separator);

  @override
  double lastWhere<double>(Function callback, {Function orElse}) => _typedList.lastWhere(callback, orElse: orElse);

  @override
  Iterable<double> map<double>(Function mapper) => _typedList.map(mapper);

  @override
  double reduce(Function reducer) => _typedList.reduce(reducer);

  @override
  double singleWhere(Function test) => _typedList.singleWhere(test);

  @override
  Iterable<double> skip(int count) => _typedList.skip(count);

  @override
  Iterable<double> skipWhile(Function test) => _typedList.skipWhile(test);

  @override
  Iterable<double> take(int count) => _typedList.take(count);

  @override
  Iterable<double> takeWhile(Function test) => _typedList.takeWhile(test);

  @override
  List<double> toList({bool growable = false}) => _typedList.toList(growable: growable);

  @override
  Set<double> toSet() => _typedList.toSet();

  @override
  String toString() => _typedList.toString();

  @override
  Iterable<double> where(Function test) => _typedList.where(test);
}
