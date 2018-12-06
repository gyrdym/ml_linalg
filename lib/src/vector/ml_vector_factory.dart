import 'package:ml_linalg/vector.dart';

abstract class MLVectorFactory<S extends List<E>, E> {
  MLVector<E> from(Iterable<double> source);
  MLVector<E> fromSIMDList(S source, [int length]);
}
