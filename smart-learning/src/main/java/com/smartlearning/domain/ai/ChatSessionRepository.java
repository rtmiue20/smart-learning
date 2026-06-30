package com.smartlearning.domain.ai;

import java.util.List;
import java.util.Optional;

public interface ChatSessionRepository {
    ChatSession save(ChatSession session);
    Optional<ChatSession> findById(Long id);
    List<ChatSession> findByStudentId(Long studentId);
    ChatMessage saveMessage(ChatMessage message);
}
