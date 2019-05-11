import 'package:ml_linalg/src/vector/common/typed_list_helper.dart';
import 'package:ml_linalg/src/vector/common/typed_list_helper_factory.dart';
import 'package:ml_linalg/src/vector/float32/typed_list_helper/float32_list_helper.dart';

class Float32ListHelperFactory implements TypedListHelperFactory {
  const Float32ListHelperFactory();

  @override
  TypedListHelper create() => Float32ListHelper();
}
