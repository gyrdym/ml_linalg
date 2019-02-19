/// A matrix norm type
///
/// [MatrixNorm.frobenius] a norm, defined by the following formula:
///
/// $ \left \| A \right \|_{F} = \sqrt{\sum_{i=1}^{m}\sum_{j=1}^{n}\left | a_{i,j} \right |^{2}} $
///
enum MatrixNorm {
  frobenius,
}
