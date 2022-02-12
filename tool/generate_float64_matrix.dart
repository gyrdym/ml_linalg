import 'dart:async';

import 'generate_class_from_template.dart';

Future<Null> generateFloat64Matrix() => generateClassFromTemplate(
  'lib/src/matrix/float64_matrix.dart',
  'lib/src/matrix/float32_matrix.dart',
);

void main() async {
  await generateFloat64Matrix();
}
