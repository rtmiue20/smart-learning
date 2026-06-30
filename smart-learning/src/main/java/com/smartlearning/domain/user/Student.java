package com.smartlearning.domain.user;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "student_profiles")
@PrimaryKeyJoinColumn(name = "user_id")
@Getter @Setter
@NoArgsConstructor
public class Student extends User {

    private Integer grade;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Parent parent;

    public Student(String email, String password, String fullName, Integer grade) {
        setEmail(email);
        setPassword(password);
        setFullName(fullName);
        setRole(Role.STUDENT);
        this.grade = grade;
    }
}
