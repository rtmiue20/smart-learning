package com.smartlearning.domain.user;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "admin_profiles")
@PrimaryKeyJoinColumn(name = "user_id")
@Getter @Setter
@NoArgsConstructor
public class Admin extends User {

    public Admin(String email, String password, String fullName) {
        setEmail(email);
        setPassword(password);
        setFullName(fullName);
        setRole(Role.ADMIN);
    }
}
