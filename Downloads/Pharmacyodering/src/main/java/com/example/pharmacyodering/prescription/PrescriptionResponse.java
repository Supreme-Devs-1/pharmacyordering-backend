package com.example.pharmacyodering.prescription;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class PrescriptionResponse {
    private Long id;
    private Long userId;
    private String username;
    private String fileUrl;
    private PrescriptionStatus status;
    private String notes;
    private LocalDateTime createdAt;
}
