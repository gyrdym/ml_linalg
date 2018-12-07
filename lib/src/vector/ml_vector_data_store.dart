abstract class MLVectorDataStore<S extends List<E>, E> {
  S data;
  int length;
  List<double> toList({bool growable = false});
}
