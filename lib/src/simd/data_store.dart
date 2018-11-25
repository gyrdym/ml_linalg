abstract class DataStore<S extends List<E>, E> {
  S data;
  int length;
  List<double> toList({bool growable = false});
}
