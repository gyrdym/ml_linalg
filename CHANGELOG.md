# Changelog

## 13.2.0
- Matrix:
  - Added LU decomposition

## 13.1.1
- Matrix:
  - Added extra test-cases for Cholesky decomposition

## 13.1.0
- Matrix: 
  - Added Cholesky decomposition
  - Added `inverse` method:
    - Cholesky inverse
    - Forward substitution inverse for triangular matrices

## 13.0.2
- Error handling improvements

## 13.0.1
- `pubspec.yaml`: 
    - `mockito` dependency updated
    - `test` dependency updated

## 13.0.0
- null-safety supported (stable)

## 13.0.0-nullsafety.0
- null-safety supported (beta)

## 12.17.10
- `xrange` v1.0.0 supported

## 12.17.9
- `README.md`: images for SIMD examples corrected

## 12.17.8
- `matrixToJson`, `fromMatrixJson`, `vectorToJson`, `fromVectorJson`:
    - `null` value handling 

## 12.17.7
- `Distance`:
    - export files for serialization functions added

## 12.17.6
- `Distance`:
    - serialization logic added
- `CI`: 
    - github actions set up

## 12.17.5
- `FUNDING.yml` created

## 12.17.4 
- `Matrix.fromRows`: copying source list instead of passing it by reference added  (issue [#100](https://github.com/gyrdym/ml_linalg/issues/100))
- `Matrix.fromColumns`: copying source list instead of passing it by reference added  (issue [#100](https://github.com/gyrdym/ml_linalg/issues/100))

## 12.17.3
- `injector` lib 1.0.9 supported

## 12.17.2
- `pubspec`:
    - `injector` dependency corrected

## 12.17.1
- `Matrix.pow`: caching removed
- `Vector.sum`: summation of SIMD lanes fixed

## 12.17.0
- `Vector`:
    - `Vector.log` method added
- `Matrix`:
    - `Matrix.log` method added

## 12.16.0
- `Matrix`:
    - `Matrix.mapElements` method added

## 12.15.0
- `Matrix`:
    - `Matrix.multiply` method added

## 12.14.0
- `Vector`:
    - `Vector.mapToVector` method added

## 12.13.0
- `Matrix`:
    - `Matrix.sum` method added
    - `Matrix.prod` method added
- `Vector`:
    - `Vector.prod` method added

## 12.12.0
- `Matrix`:
    - `Matrix.exp` method added
- `Vector`:
    - `Vector.exp` method added

## 12.11.0
- `Matrix`:
    - `Matrix.pow` method added
- `Vector`:
    - `Vector.toIntegerPower` is deprecated
    - `Vector.pow` method added

## 12.10.0
- `Matrix`:
    - `Matrix.isSquare` getter added
    - `division operator`: throwing exception added in case of square matrix 

## 12.9.0
- `Vector`: 
    - `fromJson` constructor added
    - `toJson` method added
- `vectorToJson` helper function added to public API
- `fromVectorJson` helper function added to public API

## 12.8.2
- `fromMatrixJson`: dynamic type support added to parsing

## 12.8.1
- `DType`:
    - `dTypeToJson` helper function added to public API
    - `fromDTypeJson` helper function added to public API

## 12.8.0
- `Matrix`: 
    - `fromJson` constructor added
    - `toJson` method added
- `matrixToJson` helper function added to public API
- `fromMatrixJson` helper function added to public API

## 12.7.1
- `Matrix`: `fromList` constructor, check for length of nested lists added

## 12.7.0
- `Matrix`: constructors speed up
- Float64-based matrix class added

## 12.6.0
- `Vector`: vector operations speed up
- `Float64x2Vector`: `Float64x2Vector` class created 

## 12.5.1
- `Axis`: documentation added
- `DType`: documentation added
- `Matrix`: documentation extended and corrected

## 12.5.0
- `Matrix`:
    - `Matrix.row` constructor added
    - `Matrix.column` constructor added

## 12.4.0
- `Matrix`:
    - `Matrix.diagonal` constructor added (for creation diagonal matrices)
    - `Matrix.scalar` constructor added (for creation scalar matrices)
    - `Matrix.identity` constructor added (for creation identity matrices)

## 12.3.0
- `Matrix`:
    - `mean` method added
    - `deviation` method added
    - `hasData` getter added
    - `empty` constructor added
- `Vector`:
    - `empty` constructor added

## 12.2.0
- `Vector`: 
    - `sqrt` method added

## 12.1.0
- `Matrix`:
    - `rowIndices` field added to the interface
    - `columnIndices` field added to the interface

## 12.0.2
- `xrange` 0.0.8 version supported (`integers` function used instead of `ZRange`)

## 12.0.1
- `xrange` package version locked

## 12.0.0
- `Matrix`: 
    - `pick` method removed
    - `submatrix` method replaced with `sample` method
    - `[]` operator returns `Vector` from now
- `Vector`: 
    - `randomFilled` constructor api changed, `min` and `max` args are of `num` type now
    - `fromList` constructor api changed, from now as a source expected `List<num>` instead of `List<doublet>`
    - `filled` constructor api changed, from now sampling value is a `num` instead of `double`
- Dart sdk constraint returned to 2.2.0

## 11.0.0
- Dart sdk constraint changed: from 2.2.0 to 2.4.0
- `Matrix`: `pick` method refactored
- Grinder tasks for unit testing, code analysis and coverage added

## 10.3.7
- `Matrix`: `Iterable<Iterable<double>>` implemented

## 10.3.6
- `Vector`: `randomFilled` default parameters fixed
- Tests for `Vector`'s constructors added

## 10.3.5
- readme updated: explanation images added

## 10.3.4
- Images for readme.md updated (simd architecture explanation)

## 10.3.3
- Images for readme.md added (simd architecture explanation)

## 10.3.2
- `Vector`: 
    - `hashCode` speed up
    - `randomFilled` constructor extended: `min` and `max` parameters added

## 10.3.1
- `Vector`: `hashCode` improvements

## 10.3.0
- `Vector`: `hashCode` re-implemented: now it's possible to use the vector as a map key 

## 10.2.0
- `Matrix`: `sort` method added and implemented

## 10.1.0
- `Vector`: `subvectorByRange` method added and implemented (for float32 vector)

## 10.0.4
- `pubspec.yaml`: sdk version constraint changed from `>=2.3.0` to `>=2.2.0` 

## 10.0.3
- `Float32Matrix.columns`: empty list supported as a source
- `Float32Matrix.rows`: empty list supported as a source

## 10.0.2
- `Float32Matrix.fromList`: empty list supported as a source

## 10.0.1
- Links in README corrected

## 10.0.0
- `Vector`:
    - removed possibility to mutate an instance of the Vector:
        - `isMutable` flag removed
        - `[]=` operator removed
- `Matrix`:
    - removed possibility to mutate an instance of the Matrix:
        - `setColumn` method removed
    - `insertColumns` method added
    - `Matrix.from` renamed to `Matrix.fromList`
    - `Matrix.fromFlattened` renamed to `Matrix.fromFlattenedList` 
    - benchmarks added for checking matrix initialization performance
- Performance enhancements
- Dart 2.3.0 supported

## 9.0.0
- `Vector`:
    - `Distance` enum added
    - `distanceTo` method refactored
    - cosine distance calculation added

## 8.0.0
- `Matrix`: 
    - `rows` constructor renamed to `fromRows` 
    - `columns` constructor renamed to `fromColumns` 
    - `flattened` constructor renamed to `fromFlattened` 
    - `rows` getter added 
    - `columns` getter added 

## 7.0.0
- `Matrix`: `ZRange` support (instead of the library built-in `Range`)

## 6.1.1
- `Vector`: `unique` method refactored

## 6.1.0
- `Vector`: 
    - normalize method added to interface and supported in `Float32x4Vector` 
    - rescale method added to interface and supported in `Float32x4Vector`
- `VectorBase`: cache for popular operations implemented 

## 6.0.2
- `Matrix`: `MatrixMixin` corrected

## 6.0.1
- `Vector` class refactored (get rid of redundant mixins)

## 6.0.0
- prefix `ML` removed from entities' names
- Float32x4Vector: equality operator override added
- Matrix: `uniqueRows` method added

## 5.5.1
- MLMatrix: fixed bug in `setColumn` method when rows cache was not cleared 

## 5.5.0
- MLMatrix: `setColumn` method implemented

## 5.4.0
- MLMatrix: dummy for `setColumn` method added

## 5.3.0
- MLMatrix: frobenius norm calculation added

## 5.2.0
- MLMatrix: `/` operator added
- MLMatrix: `rowsMap` method added
- MLMatrix: `columnsMap` method added

## 5.1.0
- `max` and `min` methods added for matrix 

## 5.0.1
- Travis integration added
- `dartfmt` task added

## 5.0.0
- MLVector and MLMatrix now don't have generic type parameters

## 4.2.0
- Static factories converted into abstract factories

## 4.1.0
- `toString` method specified for matrix mixin
- examples for vector operations fixed

## 4.0.0
- Vector type removed (there are no longer `column` and `row` vectors)
- Matrix's method `getColumnVector` renamed to `getColumn`
- Matrix method `getRowVector` renamed to `getRow`
- Public api documentation for `MLMatrix<E>` added

## 3.5.0
- Mutable vectors supported in matrix

## 3.4.0
- Add possibility to create mutable vectors
- Add support for value assignment via []= operator

## 3.0.3
- readme contacts section updated
- build_runner dependency updated

## 3.0.2
- readme badge corrected

## 3.0.1
- readme updated

## 3.0.0
- `vectorizedMap` vector's method improved: batch boundary indexes may be passed into a mapper function
- `columnsMap` and `rowsMap` matrix's method combined into one method - `vectorizedMap`
- Public factories `Float32x4VectorFactory` and `Float32x4MatrixFactory` renamed into `Float32x4Vector` and 
 `Float32x4Matrix`
- `copy` vector's method removed

## 2.3.0
- `pick` method added to matrix api: it's possible now to combine a new matrix from different 
   segments of a source matrix  

## 2.2.2
- README.md updated (table of content)

## 2.2.1
- Travis integration added

## 2.2.0
- Support matrices in vector operations

## 2.1.0
- Column and row vectors added

## 2.0.0
- Unnecessary generic type argument removed from `MLMatrix` class
- Matrix logic split into separate mixins 

## 1.3.0
- `MLVectorMixin` added, benchmark directory reorganized 

## 1.2.0
- Map functions added to matrix

## 1.1.0
- `Float32x4MatrixFactory` extended

## 1.0.1
- Readme updated

## 1.0.0
- Library public release
