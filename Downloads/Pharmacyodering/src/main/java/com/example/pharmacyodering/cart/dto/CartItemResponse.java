package com.example.pharmacyodering.cart.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CartItemResponse {
    private Long id;
    private Long medicineId;
    private String medicineName;
    private Integer quantity;
    private BigDecimal priceAtAddTime;
    private BigDecimal subtotal;
}

