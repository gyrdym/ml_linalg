abstract class DataGenerator<E, S extends List<E>> {
  S getDataAsList();
  Iterable<E> generate();
}
