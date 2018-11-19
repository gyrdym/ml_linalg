import 'dart:core';

import 'package:linalg/src/matrix.dart';

abstract class MatrixIterableMixin implements Iterable<Iterable<double>>, Matrix {
  @override
  bool any(bool Function(Iterable<double> element) test) {
    for (int i = 0; i < rows; i++) {
      if (test(this[i])) {
        return true;
      }
    }
    return false;
  }

  @override
  Iterable<R> cast<R>() {
    // TODO: implement cast
  }

  @override
  bool contains(Object element) {
    // TODO: implement contains
  }

  @override
  Iterable<double> elementAt(int index) {
    // TODO: implement elementAt
  }

  @override
  bool every(bool Function(Iterable<double> element) test) {
    // TODO: implement every
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Iterable<double> element) f) {
    // TODO: implement expand
  }

  // TODO: implement first
  @override
  Iterable<double> get first => null;

  @override
  Iterable<double> firstWhere(bool Function(Iterable<double> element) test, {Iterable<double> Function() orElse}) {
    // TODO: implement firstWhere
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, Iterable<double> element) combine) {
    // TODO: implement fold
  }

  @override
  Iterable<Iterable<double>> followedBy(Iterable<Iterable<double>> other) {
    // TODO: implement followedBy
  }

  @override
  void forEach(void Function(Iterable<double> element) f) {
    // TODO: implement forEach
  }

  // TODO: implement isEmpty
  @override
  bool get isEmpty => null;

  // TODO: implement isNotEmpty
  @override
  bool get isNotEmpty => null;

  // TODO: implement iterator
  @override
  Iterator<Iterable<double>> get iterator => null;

  @override
  String join([String separator = ""]) {
    // TODO: implement join
  }

  // TODO: implement last
  @override
  Iterable<double> get last => null;

  @override
  Iterable<double> lastWhere(bool Function(Iterable<double> element) test, {Iterable<double> Function() orElse}) {
    // TODO: implement lastWhere
  }

  // TODO: implement length
  @override
  int get length => null;

  @override
  Iterable<T> map<T>(T Function(Iterable<double> e) f) {
    // TODO: implement map
  }

  @override
  Iterable<double> reduce(Iterable<double> Function(Iterable<double> value, Iterable<double> element) combine) {
    // TODO: implement reduce
  }

  // TODO: implement single
  @override
  Iterable<double> get single => null;

  @override
  Iterable<double> singleWhere(bool Function(Iterable<double> element) test, {Iterable<double> Function() orElse}) {
    // TODO: implement singleWhere
  }

  @override
  Iterable<Iterable<double>> skip(int count) {
    // TODO: implement skip
  }

  @override
  Iterable<Iterable<double>> skipWhile(bool Function(Iterable<double> value) test) {
    // TODO: implement skipWhile
  }

  @override
  Iterable<Iterable<double>> take(int count) {
    // TODO: implement take
  }

  @override
  Iterable<Iterable<double>> takeWhile(bool Function(Iterable<double> value) test) {
    // TODO: implement takeWhile
  }

  @override
  List<Iterable<double>> toList({bool growable: true}) {
    // TODO: implement toList
  }

  @override
  Set<Iterable<double>> toSet() {
    // TODO: implement toSet
  }

  @override
  Iterable<Iterable<double>> where(bool Function(Iterable<double> element) test) {
    // TODO: implement where
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
  }

}
