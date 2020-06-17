const matrixMeansByRowsKey = 'means_by_rows';
const matrixMeansByColumnsKey = 'means_by_columns';
const matrixDeviationByRowsKey = 'deviation_by_rows';
const matrixDeviationByColumnsKey = 'deviation_by_columns';
const matrixExpKey = 'exp';
const matrixLogKey = 'log';
const matrixSumKey = 'sum';
const matrixProdKey = 'prod';

final matrixCacheKeys = Set<String>.from(<String>[
  matrixMeansByRowsKey,
  matrixMeansByColumnsKey,
  matrixDeviationByRowsKey,
  matrixDeviationByColumnsKey,
  matrixExpKey,
  matrixLogKey,
  matrixSumKey,
  matrixProdKey,
]);
