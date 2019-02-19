/// A matrix norm type
///
/// [MatrixNorm.frobenius] a norm, defined by the following formula:
///
/// ![\left \| A \right \|_{F} = \sqrt{\sum_{i=1}^{m}\sum_{j=1}^{n}\left | a_{i,j} \right |^{2}}](https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cleft%20%5C%7C%20A%20%5Cright%20%5C%7C_%7BF%7D%20%3D%20%5Csqrt%7B%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%5Csum_%7Bj%3D1%7D%5E%7Bn%7D%5Cleft%20%7C%20a_%7Bi%2Cj%7D%20%5Cright%20%7C%5E%7B2%7D%7D)
enum MatrixNorm {
  frobenius,
}
