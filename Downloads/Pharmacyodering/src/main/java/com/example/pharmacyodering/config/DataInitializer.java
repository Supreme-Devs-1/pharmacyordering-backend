package com.example.pharmacyodering.config;

import com.example.pharmacyodering.user.Role;
import com.example.pharmacyodering.user.RoleRepository;
import com.example.pharmacyodering.user.User;
import com.example.pharmacyodering.user.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@Component
public class DataInitializer implements CommandLineRunner {

    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(RoleRepository roleRepository, UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.roleRepository = roleRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(String... args) {
        Role userRole = ensureRoleExists("ROLE_USER");
        Role adminRole = ensureRoleExists("ROLE_ADMIN");
        ensureAdminUser(adminRole, userRole);
    }

    private Role ensureRoleExists(String roleName) {
        return roleRepository.findByName(roleName).orElseGet(() -> {
            Role role = new Role();
            role.setName(roleName);
            return roleRepository.save(role);
        });
    }

    private void ensureAdminUser(Role adminRole, Role userRole) {
        userRepository.findByUsername("admin").orElseGet(() -> {
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@example.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRoles(Set.of(adminRole, userRole));
            return userRepository.save(admin);
        });
    }
}
