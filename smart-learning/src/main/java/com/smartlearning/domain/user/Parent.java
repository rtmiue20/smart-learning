package com.smartlearning.domain.user;

import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "parent_profiles")
@PrimaryKeyJoinColumn(name = "user_id")
@Getter @Setter
@NoArgsConstructor
public class Parent extends User {

    @OneToMany(mappedBy = "parent", fetch = FetchType.LAZY)
    private List<Student> children = new ArrayList<>();

    public Parent(String email, String password, String fullName) {
        setEmail(email);
        setPassword(password);
        setFullName(fullName);
        setRole(Role.PARENT);
    }
}
