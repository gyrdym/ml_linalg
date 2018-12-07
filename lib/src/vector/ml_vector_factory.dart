import 'package:ml_linalg/vector.dart';

abstract class MLVectorFactory<S extends List<E>, E> {
  MLVector<E> vectorFrom(Iterable<double> source);
  MLVector<E> vectorFromSIMDList(S source, [int length]);
}
