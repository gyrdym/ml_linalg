/// A type of vector distance
///
/// Actually, it's a measure of similarity of two vectors: the greater the
/// distance, the less similar the vectors are and vice versa
///
/// [Distance.euclidean] Distance, calculated according to the formula:
///
/// ![\[D = \sqrt{\sum_{i = 1}^{n}(A_{i} - B_{i})^{2}}\]](https://latex.codecogs.com/gif.latex?D%20%3D%20%5Csqrt%7B%5Csum_%7Bi%20%3D%201%7D%5E%7Bn%7D%28A_%7Bi%7D%20-%20B_%7Bi%7D%29%5E%7B2%7D%7D)
///
/// [Distance.manhattan] Distance, as known as *Taxicab* distance. It's
/// calculated according to the formula:
///
/// ![\[D = \sum_{i = 1}^{n}\left |A_{i} - B_{i} \right |\]](https://latex.codecogs.com/gif.latex?D%20%3D%20%5Csum_%7Bi%20%3D%201%7D%5E%7Bn%7D%5Cleft%20%7CA_%7Bi%7D%20-%20B_%7Bi%7D%20%5Cright%20%7C)
///
/// [Distance.cosine] Distance, based on vector orientation, or rather on cosine
/// of the angle between two vectors: the more the angle, the less similar the
/// vectors are. It's calculated according to the formula:
///
/// ![\[D = 1 - cos(\theta ) = 1 - \frac{A\cdot B}{\left \| A \right \|\left \| B \right \|}\]](https://latex.codecogs.com/gif.latex?D%20%3D%201%20-%20cos%28%5Ctheta%20%29%20%3D%201%20-%20%5Cfrac%7BA%5Ccdot%20B%7D%7B%5Cleft%20%5C%7C%20A%20%5Cright%20%5C%7C%5Cleft%20%5C%7C%20B%20%5Cright%20%5C%7C%7D)
///
/// A case, when two vectors have the greatest similarity according to this
/// distance, is when the angle between them is equal to 0 degrees. The
/// angle's cosine in this case is equal to 1.
///
/// This distance is good for determining similarity of 2 sparse vectors (a
/// case, when vector norms are disparate)
///
/// [Distance.hamming] Distance, calculated according to the formula:
///
/// ![\[D = \sum_{i = 1}^{n} A_{i} \neq B_{i}\]](https://latex.codecogs.com/gif.latex?D%20%3D%20%5Csum_%7Bi%20%3D%201%7D%5E%7Bn%7D%20A_%7Bi%7D%20%5Cneq%20B_%7Bi%7D)
///
/// In other words, the distance is calculated based on a number of elements
/// whose values are different: the more the number, the less similar the
/// vectors are
enum Distance {euclidean, manhattan, cosine, hamming}
