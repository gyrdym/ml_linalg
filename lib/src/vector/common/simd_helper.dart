abstract class SimdHelper<E, S extends List<E>> {
  /// performs summation of all components of passed simd value [a]
  double sumLanes(E a);

  /// Performs summation of the lanes of the given simd value to provide a
  /// hashcode. The method handles infinite and NaN values.
  double sumLanesForHash(E a);

  /// returns a maximal element (lane) of [a]
  double getMaxLane(E a);

  /// returns a minimal element (lane) of [a]
  double getMinLane(E a);

  /// converts simd value [a] to regular list
  List<double> simdValueToList(E a);
}
