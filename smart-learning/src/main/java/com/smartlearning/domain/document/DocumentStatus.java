package com.smartlearning.domain.document;

public enum DocumentStatus {
    PENDING,       // vừa upload, chưa xử lý
    PROCESSING,    // đang extract + embedding
    READY,         // sẵn sàng cho RAG
    FAILED         // lỗi xử lý
}
