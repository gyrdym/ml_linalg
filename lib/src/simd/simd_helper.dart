import 'package:linalg/src/vector.dart';

abstract class SIMDHelper<S extends List<E>, T extends List<double>, E> {
  /// number of lanes (it is 2 or 4 elements currently supported to be processed simultaneously, this characteristic
  /// restricted by computing platform architecture)
  int get bucketSize;
  E createSIMDFilled(double value);
  E createSIMDFromSimpleList(List<double> list);
  E simdSum(E a, E b);
  E simdSub(E a, E b);
  E simdMul(E a, E b);
  E simdDiv(E a, E b);
  E simdAbs(E a);
  double singleSIMDSum(E a);
  S createSIMDList(int length);
  T createTypedList(int length);
  T createTypedListFromList(List<double> list);
  Vector createVectorFromSIMDList(S list, int length);
  Vector createVectorFromList(List<double> list);
  double getScalarByOffsetIndex(E value, int offset);
  E selectMax(E a, E b);
  double getMaxLane(E a);
  E selectMin(E a, E b);
  double getMinLane(E a);
  List<double> simdToList(E a);
}
