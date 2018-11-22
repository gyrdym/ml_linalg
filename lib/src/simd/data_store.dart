import 'dart:typed_data';

abstract class DataStore<S extends TypedData> {
  S data;
  int length;
  List<double> toList({bool growable = false});
}
