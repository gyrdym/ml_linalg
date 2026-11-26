import 'dart:async';

import 'generate_class_from_template.dart';

Future<Null> generateFloat64MutableMatrix() => generateClassFromTemplate(
      'lib/src/matrix/float64_mutable_matrix.g.dart',
      'lib/src/matrix/float32_mutable_matrix.dart',
    );

void main() async {
  await generateFloat64MutableMatrix();
}
