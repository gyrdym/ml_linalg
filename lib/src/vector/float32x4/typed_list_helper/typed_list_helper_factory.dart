import 'package:ml_linalg/src/vector/common/typed_list_helper.dart';
import 'package:ml_linalg/src/vector/common/typed_list_helper_factory.dart';
import 'package:ml_linalg/src/vector/float32x4/typed_list_helper/typed_list_helper.dart';

class Float32ListHelperFactory implements TypedListHelperFactory {
  const Float32ListHelperFactory();

  @override
  TypedListHelper create() => Float32ListHelper();
}