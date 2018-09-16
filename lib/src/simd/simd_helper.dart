import 'package:linalg/src/vector.dart';

abstract class SIMDHelper<SIMDListType extends List, SIMDValueType, TypedListType extends List> {
  /// number of lanes (it is 2 or 4 elements currently supported to be processed simultaneously, this characteristic
  /// restricted by computing platform architecture)
  int get bucketSize;
  SIMDValueType createSIMDFilled(double value);
  SIMDValueType createSIMDFromSimpleList(List<double> list);
  SIMDValueType SIMDProduct(SIMDValueType a, SIMDValueType b);
  SIMDValueType SIMDSum(SIMDValueType a, SIMDValueType b);
  SIMDValueType SIMDAbs(SIMDValueType a);
  double singleSIMDSum(SIMDValueType a);
  SIMDListType createSIMDList(int length);
  TypedListType createTypedList(int length);
  TypedListType createTypedListFromList(List<double> list);
  Vector createVectorFromSIMDList(SIMDListType list, int length);
  Vector createVectorFromList(List<double> list);
  double getScalarByOffsetIndex(SIMDValueType value, int offset);
  SIMDValueType selectMax(SIMDValueType a, SIMDValueType b);
  double getMaxLane(SIMDValueType a);
  SIMDValueType selectMin(SIMDValueType a, SIMDValueType b);
  double getMinLane(SIMDValueType a);
  List<double> SIMDToList(SIMDValueType a);
}
