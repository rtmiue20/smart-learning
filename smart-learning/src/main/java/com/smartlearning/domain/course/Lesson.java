package com.smartlearning.domain.course;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "lessons")
@Getter @Setter
@NoArgsConstructor
public class Lesson {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chapter_id", nullable = false)
    private Chapter chapter;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex = 0;

    public Lesson(Chapter chapter, String title, String content, Integer orderIndex) {
        this.chapter = chapter;
        this.title = title;
        this.content = content;
        this.orderIndex = orderIndex;
    }
}
