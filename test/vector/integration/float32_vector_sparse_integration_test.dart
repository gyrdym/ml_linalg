import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/vector/float32_vector_sparse.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

/// Integration-style smoke test for sparse vectors without mocks.
///
/// Models a tiny on-device text scenario: bag-of-words vectors over a large
/// vocabulary, TF scaling, cosine ranking and feature intersection.
void main() {
  group('Float32VectorSparse integration', () {
    // Vocabulary-sized feature space with only a handful of present terms.
    const vocabSize = 50000;

    // termId -> raw count
    const queryTerms = <int, num>{
      12: 1,
      450: 2,
      8900: 1,
      12000: 3,
      48001: 1,
    };

    const documentTerms = <int, num>{
      12: 2,
      450: 1,
      3300: 4,
      12000: 1,
      22000: 2,
      48001: 1,
    };

    late Float32VectorSparse query;
    late Float32VectorSparse document;

    setUp(() {
      query = Float32VectorSparse.fromMap(queryTerms, length: vocabSize);
      document =
          Float32VectorSparse.fromMap(documentTerms, length: vocabSize);
    });

    test('should keep bag-of-words vectors compressed over a large vocabulary',
        () {
      expect(query.length, vocabSize);
      expect(document.length, vocabSize);
      expect(query.nnz, queryTerms.length);
      expect(document.nnz, documentTerms.length);

      // Absent terms are real zeros, not stored entries.
      expect(query[0], 0.0);
      expect(query[12], 1.0);
      expect(query[12000], 3.0);
      expect(document[3300], 4.0);
      expect(document[9999], 0.0);
    });

    test('should rank a document against a query with sparse cosine similarity',
        () {
      // Simple TF scaling: emphasize repeated terms.
      final scaledQuery = query * 1.0;
      final scaledDocument = document * 1.0;

      expect(scaledQuery, isA<Float32VectorSparse>());
      expect(scaledDocument, isA<Float32VectorSparse>());
      expect((scaledQuery as Float32VectorSparse).nnz, query.nnz);
      expect((scaledDocument as Float32VectorSparse).nnz, document.nnz);

      final score = scaledQuery.distanceTo(
        scaledDocument,
        distance: Distance.cosine,
      );

      // Cosine distance in [0, 2]; overlapping BoW vectors should be similar.
      expect(score, greaterThanOrEqualTo(0.0));
      expect(score, lessThan(1.0));

      final denseQuery =
          Vector.fromList(query.toList(), dtype: DType.float32);
      final denseDocument =
          Vector.fromList(document.toList(), dtype: DType.float32);
      final denseScore = denseQuery.distanceTo(
        denseDocument,
        distance: Distance.cosine,
      );

      expect(score, closeTo(denseScore, 1e-5));
    });

    test('should intersect features with sparse element-wise multiply', () {
      final overlap = query * document;

      expect(overlap, isA<Float32VectorSparse>());
      expect((overlap as Float32VectorSparse).nnz, 4);
      expect(overlap[12], 2.0); // 1 * 2
      expect(overlap[450], 2.0); // 2 * 1
      expect(overlap[12000], 3.0); // 3 * 1
      expect(overlap[48001], 1.0); // 1 * 1
      expect(overlap[3300], 0.0); // present only in document
      expect(overlap[8900], 0.0); // present only in query

      // Shared-term mass via sparse-friendly reductions.
      expect(overlap.sum(), 8.0);
      expect(overlap.dot(Vector.filled(vocabSize, 1.0)), 8.0);
      expect(overlap.norm(Norm.manhattan), 8.0);
    });

    test('should update a live sparse representation through set', () {
      final updated = query.set(12, 0).set(42, 5) as Float32VectorSparse;

      expect(updated.nnz, query.nnz); // removed one, added one
      expect(updated[12], 0.0);
      expect(updated[42], 5.0);
      expect(updated[12000], 3.0);

      final refreshedScore = updated.distanceTo(
        document,
        distance: Distance.cosine,
      );

      expect(refreshedScore.isFinite, isTrue);
      expect(refreshedScore, greaterThanOrEqualTo(0.0));
    });
  });
}
