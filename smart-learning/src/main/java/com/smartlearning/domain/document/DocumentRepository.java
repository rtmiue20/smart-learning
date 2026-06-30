package com.smartlearning.domain.document;

import java.util.List;
import java.util.Optional;

public interface DocumentRepository {
    Document save(Document document);
    Optional<Document> findById(Long id);
    List<Document> findBySubjectId(Long subjectId);
    List<Document> findByStatus(DocumentStatus status);
    EmbeddingChunk saveChunk(EmbeddingChunk chunk);
}
