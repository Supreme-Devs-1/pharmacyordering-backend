package com.example.pharmacyodering.controller;

import com.example.pharmacyodering.cart.CartService;
import com.example.pharmacyodering.cart.dto.AddToCartRequest;
import com.example.pharmacyodering.cart.dto.CartResponse;
import com.example.pharmacyodering.user.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@SecurityRequirement(name = "bearerAuth")
@RestController
@RequestMapping("/api/cart")
@Tag(name = "Cart", description = "Cart management endpoints")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    /**
     * Add medicine to cart
     * POST /api/cart/add
     */
    @PostMapping("/add")
    @Operation(summary = "Add medicine to cart", description = "Add a medicine to the user's cart or update quantity if it already exists")
    public ResponseEntity<CartResponse> addToCart(
            @AuthenticationPrincipal User user,
            @RequestBody AddToCartRequest request) {
        try {
            CartResponse cartResponse = cartService.addToCart(user, request);
            return ResponseEntity.ok(cartResponse);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    /**
     * Get user's cart
     * GET /api/cart
     */
    @GetMapping
    @Operation(summary = "Get user's cart", description = "Retrieve the current user's shopping cart with all items")
    public ResponseEntity<CartResponse> getCart(@AuthenticationPrincipal User user) {
        try {
            CartResponse cartResponse = cartService.getCart(user);
            return ResponseEntity.ok(cartResponse);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Remove medicine from cart
     * DELETE /api/cart/remove/{medicineId}
     */
    @DeleteMapping("/remove/{medicineId}")
    @Operation(summary = "Remove medicine from cart", description = "Remove a specific medicine from the user's cart")
    public ResponseEntity<CartResponse> removeFromCart(
            @AuthenticationPrincipal User user,
            @PathVariable Long medicineId) {
        try {
            CartResponse cartResponse = cartService.removeFromCart(user, medicineId);
            return ResponseEntity.ok(cartResponse);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    /**
     * Clear entire cart
     * DELETE /api/cart (bonus endpoint)
     */
    @DeleteMapping
    @Operation(summary = "Clear cart", description = "Remove all items from the user's cart")
    public ResponseEntity<Void> clearCart(@AuthenticationPrincipal User user) {
        try {
            cartService.clearCart(user);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }
}

