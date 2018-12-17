# Changelog

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
