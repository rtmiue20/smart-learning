package com.smartlearning.domain.progress;

import com.smartlearning.domain.course.Lesson;
import com.smartlearning.domain.user.Student;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "learning_progress",
       uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "lesson_id"}))
@Getter @Setter
@NoArgsConstructor
public class LearningProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    private Lesson lesson;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ProgressStatus status = ProgressStatus.NOT_STARTED;

    @Column(name = "completion_percent")
    private Integer completionPercent = 0;

    @Column(name = "last_accessed_at")
    private LocalDateTime lastAccessedAt;

    @PrePersist
    @PreUpdate
    protected void onAccess() {
        lastAccessedAt = LocalDateTime.now();
    }

    public LearningProgress(Student student, Lesson lesson) {
        this.student = student;
        this.lesson = lesson;
    }

    public void markCompleted() {
        this.status = ProgressStatus.COMPLETED;
        this.completionPercent = 100;
    }

    public void updateProgress(int percent) {
        this.completionPercent = Math.min(percent, 100);
        this.status = completionPercent >= 100 ? ProgressStatus.COMPLETED : ProgressStatus.IN_PROGRESS;
    }
}
