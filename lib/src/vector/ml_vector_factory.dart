import 'package:ml_linalg/vector.dart';
import 'package:ml_linalg/vector_type.dart';

abstract class MLVectorFactory<S extends List<E>, E> {
  MLVector<E> createVectorFrom(Iterable<double> source, [MLVectorType type = MLVectorType.column]);
  MLVector<E> createVectorFromSIMDList(S source, [int length, MLVectorType type = MLVectorType.column]);
}
