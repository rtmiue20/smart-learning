package com.smartlearning.domain.quiz;

import java.util.List;
import java.util.Optional;

public interface QuizRepository {
    Optional<Quiz> findById(Long id);
    List<Quiz> findByLessonId(Long lessonId);
    Submission saveSubmission(Submission submission);
    List<Submission> findSubmissionsByStudentId(Long studentId);
}
