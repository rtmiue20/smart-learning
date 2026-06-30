package com.smartlearning.domain.user;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "teacher_profiles")
@PrimaryKeyJoinColumn(name = "user_id")
@Getter @Setter
@NoArgsConstructor
public class Teacher extends User {

    @Column(columnDefinition = "TEXT")
    private String bio;

    public Teacher(String email, String password, String fullName) {
        setEmail(email);
        setPassword(password);
        setFullName(fullName);
        setRole(Role.TEACHER);
    }
}
