import 'package:ml_linalg/dtype.dart';

const dtypeToMatrixTestTitle = {
  DType.float32: 'Float32-based matrix',
  DType.float64: 'Float64-based matrix',
};

const dtypeToMatrixIteratorTestTitle = {
  DType.float32: 'Float32MatrixIterator',
  DType.float64: 'Float64MatrixIterator',
};

const dtypeToVectorTestTitle = {
  DType.float32: 'Float32x4Vector',
  DType.float64: 'Float64x4Vector',
};

const dtypeToInverseDType = {
  DType.float32: DType.float64,
  DType.float64: DType.float32,
};
