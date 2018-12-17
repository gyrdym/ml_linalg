import 'package:ml_linalg/vector.dart';

abstract class MLVectorFactory<S extends List<E>, E> {
  MLVector<E> createVectorFrom(Iterable<double> source, [bool mutable = false]);
  MLVector<E> createVectorFromSIMDList(S source, [int length, bool mutable = false]);
}
