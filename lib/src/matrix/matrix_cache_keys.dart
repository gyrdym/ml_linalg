const meansByRowsKey = 'means_by_rows';
const meansByColumnsKey = 'means_by_columns';
const deviationByRowsKey = 'deviation_by_rows';
const deviationByColumnsKey = 'deviation_by_columns';

final matrixCacheKeys = Set<String>.from(<String>[
  meansByRowsKey,
  meansByColumnsKey,
  deviationByRowsKey,
  deviationByColumnsKey,
]);
