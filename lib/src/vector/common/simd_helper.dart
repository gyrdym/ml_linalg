import 'dart:typed_data';

abstract class SimdHelper<E, S extends List<E>> {
  /// creates a simd-value filled with [value]
  E createFilled(double value);

  /// performs summation of two simd values
  E sum(E a, E b);

  /// performs subtraction of two simd values
  E sub(E a, E b);

  /// performs multiplication of two simd values
  E mul(E a, E b);

  /// performs a simd value scaling
  E scale(E a, double scalar);

  /// performs division of two simd values
  E div(E a, E b);

  /// returns an absolute value of given [a]
  E abs(E a);

  /// performs summation of all components of passed simd value [a]
  double sumLanes(E a);

  /// returns a simd list of length equals [length]
  S createList(int length);

  /// returns a simd list created from [source]
  S createListFrom(List<E> source);

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
  List<double> simdValueToList(E a);

  S getBufferAsSimdList(ByteBuffer buffer);
}
