abstract class SimdHelper<E> {
  bool areLanesEqual(E a, E b);

  /// performs summation of all components of passed simd value [a]
  double sumLanes(E a);

  /// performs multiplication of all components of passed simd value [a]
  double multLanes(E a);

  /// Performs summation of the lanes of the given simd value to provide a
  /// hashcode. The method handles infinite and NaN values.
  double sumLanesForHash(E a);

  /// returns a maximal element (lane) of [a]
  double getMaxLane(E a);

  /// returns a minimal element (lane) of [a]
  double getMinLane(E a);

  /// converts simd value [a] to regular list of length [limit] but not greater
  /// than the simd value size
  List<double> simdValueToList(E a, [int limit]);

  /// Raises all the lanes of [a] to the [exponent]
  E pow(E a, num exponent);
}
