import 'package:ml_linalg/src/vector/common/typed_list_factory.dart';
import 'package:ml_linalg/src/vector/common/typed_list_factory_factory.dart';
import 'package:ml_linalg/src/vector/float32x4/typed_list_factory/typed_list_factory.dart';

class Float32ListFactoryFactory implements TypedListFactoryFactory {
  const Float32ListFactoryFactory();

  @override
  TypedListFactory create() => Float32ListFactory();
}
