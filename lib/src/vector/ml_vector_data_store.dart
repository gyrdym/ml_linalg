abstract class MLVectorDataStore<S> {
  S data;
  int length;
  List<double> toList({bool growable = false});
}
