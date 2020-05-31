const meansByRowsKey = 'means_by_rows';
const meansByColumnsKey = 'means_by_columns';
const deviationByRowsKey = 'deviation_by_rows';
const deviationByColumnsKey = 'deviation_by_columns';
const matrixPowKey = 'pow';
const matrixExpKey = 'exp';
const matrixSumKey = 'sum';
const matrixProdKey = 'prod';

final matrixCacheKeys = Set<String>.from(<String>[
  meansByRowsKey,
  meansByColumnsKey,
  deviationByRowsKey,
  deviationByColumnsKey,
  matrixPowKey,
  matrixExpKey,
  matrixSumKey,
  matrixProdKey,
]);
