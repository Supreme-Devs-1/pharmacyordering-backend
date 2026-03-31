package com.example.pharmacyodering.auth;

import com.example.pharmacyodering.auth.dto.AuthResponse;
import com.example.pharmacyodering.auth.dto.LoginRequest;
import com.example.pharmacyodering.auth.dto.ProfileResponse;
import com.example.pharmacyodering.auth.dto.RegisterRequest;
import com.example.pharmacyodering.user.User;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @GetMapping("/profile")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<ProfileResponse> profile(@AuthenticationPrincipal User user) {
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
}
