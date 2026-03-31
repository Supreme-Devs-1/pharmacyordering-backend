package com.example.pharmacyodering.controller;

import com.example.pharmacyodering.auth.dto.ProfileResponse;
import com.example.pharmacyodering.service.UserService;
import com.example.pharmacyodering.user.User;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;
import java.util.stream.Collectors;

@SecurityRequirement(name = "bearerAuth")
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    public ResponseEntity<ProfileResponse> me(@AuthenticationPrincipal User user) {
        Set<String> roleNames = user.getRoles() == null ? Set.of() :
                user.getRoles().stream().map(r -> r.getName()).collect(Collectors.toSet());

        ProfileResponse response = new ProfileResponse(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                roleNames
        );

        return ResponseEntity.ok(response);
    }

    @GetMapping("/admin/check")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> adminCheck() {
        return ResponseEntity.ok("ADMIN_ACCESS_OK");
    }
}
