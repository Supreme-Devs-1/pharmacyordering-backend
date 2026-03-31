package com.example.pharmacyodering.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderResponse {
    private Long id;
    private Long userId;
    private String username;
    private String status;
    private BigDecimal totalAmount;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

