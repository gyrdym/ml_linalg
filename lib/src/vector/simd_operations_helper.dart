abstract class SimdOperationsHelper<E, S extends List<E>> {
  /// number of lanes (it is 2 or 4 elements currently supported to be processed simultaneously, this characteristic
  /// restricted by computing platform architecture)
  int get bucketSize;

  /// creates a simd-value filled with [value]
  E createSimdFilled(double value);

  /// creates a simd-value from passed [list]
  E createSimdFromSimpleList(List<double> list);

  /// performs summation of two simd values
  E simdSum(E a, E b);

  /// performs subtraction of two simd values
  E simdSub(E a, E b);

  /// performs multiplication of two simd values
  E simdMul(E a, E b);

  /// performs a simd value scaling
  E simdScale(E a, double scalar);

  /// performs division of two simd values
  E simdDiv(E a, E b);

  /// returns an absolute value of given [a]
  E simdAbs(E a);

  /// performs summation of all components of passed simd value [a]
  double singleSIMDSum(E a);

  /// returns a typed simd list of length equals [length]
  S createSIMDList(int length);

  /// returns particular component (lane) of simd value [value] by offset
  double getScalarByOffsetIndex(E value, int offset);

  /// prepares a simd value comprised of maximum values of both [a] and [b]
  E selectMax(E a, E b);

  bool areValuesEqual(E a, E b);

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

  E mutateSimdValueWithScalar(E simd, int offset, double scalar);
}
