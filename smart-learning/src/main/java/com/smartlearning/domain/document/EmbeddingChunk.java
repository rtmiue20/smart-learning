package com.smartlearning.domain.document;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "embedding_chunks")
@Getter @Setter
@NoArgsConstructor
public class EmbeddingChunk {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "document_id", nullable = false)
    private Document document;

    @Column(name = "chunk_index", nullable = false)
    private Integer chunkIndex;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    // Vector ID lưu trong Qdrant/VectorDB, không lưu vector thực trong MariaDB
    @Column(name = "vector_id")
    private String vectorId;

    public EmbeddingChunk(Document document, Integer chunkIndex, String content) {
        this.document = document;
        this.chunkIndex = chunkIndex;
        this.content = content;
    }
}
