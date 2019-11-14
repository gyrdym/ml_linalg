import 'dart:async';

import 'generate_class_from_template.dart';

Future<Null> generateFloat64x2Vector() => generateClassFromTemplate(
  'lib/src/vector/float64x2_vector.dart',
  'lib/src/vector/float32x4_vector.dart',
);

Future<Null> main() async {
  await generateFloat64x2Vector();
}
