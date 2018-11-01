import 'dart:typed_data' show ByteBuffer, ByteData;

abstract class SIMDHelper<S extends List<E>, T extends List<double>, E> {
  /// number of lanes (it is 2 or 4 elements currently supported to be processed simultaneously, this characteristic
  /// restricted by computing platform architecture)
  int get bucketSize;

  /// creates a simd-value filled with [value]
  E createSIMDFilled(double value);

  /// creates a simd-value from passed [list]
  E createSIMDFromSimpleList(List<double> list);

  /// performs summation of two simd values
  E simdSum(E a, E b);

  /// performs subtraction of two simd values
  E simdSub(E a, E b);

  /// performs multiplication of two simd values
  E simdMul(E a, E b);

  /// performs division of two simd values
  E simdDiv(E a, E b);

  /// returns an absolute value of given [a]
  E simdAbs(E a);

  /// performs summation of all components of passed simd value [a]
  double singleSIMDSum(E a);

  /// returns a typed simd list of length equals [length]
  S createSIMDList(int length);

  /// returns a typed list with
  T createTypedListFromByteBuffer(ByteBuffer data);

  /// returns a typed list (e.g. Float32List) of length equals [length]
  T createTypedList(int length);

  /// returns a typed list (e.g. Float32List) created using [list] as a source
  T createTypedListFromList(List<double> list);

  /// returns particular component (lane) of simd value [value] by offset
  double getScalarByOffsetIndex(E value, int offset);

  /// prepares a simd value comprised of maximum values of both [a] and [b]
  E selectMax(E a, E b);

  /// returns a maximal element (lane) of [a]
  double getMaxLane(E a);

  /// prepares a simd value comprised of minimum values of both [a] and [b]
  E selectMin(E a, E b);

  /// returns a minimal element (lane) of [a]
  double getMinLane(E a);

  /// converts simd value [a] to regular list
  List<double> simdToList(E a);

  List<double> takeFirstNLanes(E a, int n);

  S sublist(S list, int start, [int end]);

  T bufferAsTypedList(ByteBuffer buffer, int start, int length);
}
