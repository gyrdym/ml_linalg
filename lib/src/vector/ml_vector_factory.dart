import 'package:ml_linalg/vector.dart';

abstract class MLVectorFactory<S> {
  MLVector createVectorFrom(Iterable<double> source, [bool mutable = false]);
  MLVector createVectorFromSIMDList(S source, [int length, bool mutable = false]);
}
