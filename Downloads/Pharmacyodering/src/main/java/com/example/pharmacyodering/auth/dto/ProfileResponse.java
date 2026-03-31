package com.example.pharmacyodering.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Set;

@Getter
@AllArgsConstructor
public class ProfileResponse {
    private final Long id;
    private final String username;
    private final String email;
    private final Set<String> roles;
}
