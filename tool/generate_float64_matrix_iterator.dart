import 'dart:async';

import 'generate_class_from_template.dart';

Future<Null> generateFloat64MatrixIterator() => generateClassFromTemplate(
      'lib/src/matrix/iterator/float64_matrix_iterator.dart',
      'lib/src/matrix/iterator/float32_matrix_iterator.dart',
    );

void main() async {
  await generateFloat64MatrixIterator();
}
