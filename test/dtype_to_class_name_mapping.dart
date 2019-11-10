import 'package:ml_linalg/dtype.dart';

const dtypeToMatrixClassName = {
  DType.float32: 'Float32Matrix',
  DType.float64: 'Float64Matrix',
};

const dtypeToVectorClassName = {
  DType.float32: 'Float32x4Vector',
  DType.float64: 'Float64x4Vector',
};
