abstract class MLVectorDataStore<E, S extends List<E>> {
  S data;
  int length;
  List<double> toList({bool growable = false});
}
