import 'package:ml_linalg/vector.dart';

abstract class MLVectorFactory<E, S extends List<E>> {
  MLVector createVectorFrom(Iterable<double> source, [bool mutable = false]);
  MLVector createVectorFromSIMDList(S source, [int length, bool mutable = false]);
}
