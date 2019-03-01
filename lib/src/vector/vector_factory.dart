import 'package:ml_linalg/vector.dart';

abstract class VectorFactory<E, S extends List<E>> {
  Vector createVectorFrom(Iterable<double> source, [bool mutable = false]);
  Vector createVectorFromSIMDList(S source,
      [int length, bool mutable = false]);
}
