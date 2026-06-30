package com.smartlearning.domain.course;

import java.util.List;
import java.util.Optional;

public interface CourseRepository {
    List<Subject> findAllSubjects();
    List<Subject> findSubjectsByGrade(Integer grade);
    Optional<Subject> findSubjectById(Long id);
    List<Chapter> findChaptersBySubjectId(Long subjectId);
    Optional<Lesson> findLessonById(Long id);
    Subject saveSubject(Subject subject);
}
