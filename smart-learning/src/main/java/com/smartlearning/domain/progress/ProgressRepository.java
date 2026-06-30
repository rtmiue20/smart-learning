package com.smartlearning.domain.progress;

import java.util.List;
import java.util.Optional;

public interface ProgressRepository {
    Optional<LearningProgress> findByStudentIdAndLessonId(Long studentId, Long lessonId);
    List<LearningProgress> findByStudentId(Long studentId);
    LearningProgress save(LearningProgress progress);
}
