package com.example.pharmacyodering.controller;

import com.example.pharmacyodering.order.OrderService;
import com.example.pharmacyodering.order.dto.CreateOrderRequest;
import com.example.pharmacyodering.order.dto.OrderResponse;
import com.example.pharmacyodering.order.dto.UpdateOrderStatusRequest;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@Tag(name = "Orders", description = "Order management endpoints")
@SecurityRequirement(name = "bearerAuth")
public class OrderController {
    
    private final OrderService orderService;
    
    /**
     * Create a new order
     * POST /api/orders
     */
    @PostMapping
    @Operation(summary = "Create a new order", description = "Creates a new order for the authenticated user")
    public ResponseEntity<OrderResponse> createOrder(@RequestBody CreateOrderRequest request) {
        OrderResponse response = orderService.createOrder(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
    
    /**
     * Get order by ID
     * GET /api/orders/{id}
     */
    @GetMapping("/{id}")
    @Operation(summary = "Get order by ID", description = "Retrieves a specific order by its ID")
    public ResponseEntity<OrderResponse> getOrderById(@PathVariable Long id) {
        OrderResponse response = orderService.getOrderById(id);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get all orders for a specific user
     * GET /api/orders/user/{userId}
     */
    @GetMapping("/user/{userId}")
    @Operation(summary = "Get orders by user ID", description = "Retrieves all orders for a specific user")
    public ResponseEntity<List<OrderResponse>> getOrdersByUserId(@PathVariable Long userId) {
        List<OrderResponse> orders = orderService.getOrdersByUserId(userId);
        return ResponseEntity.ok(orders);
    }
    
    /**
     * Update order status
     * PUT /api/orders/{id}/status
     */
    @PutMapping("/{id}/status")
    @Operation(summary = "Update order status", description = "Updates the status of an order (PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED)")
    public ResponseEntity<OrderResponse> updateOrderStatus(
            @PathVariable Long id,
            @RequestBody UpdateOrderStatusRequest request) {
        OrderResponse response = orderService.updateOrderStatus(id, request.getStatus());
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get orders by status
     * GET /api/orders?status={status}
     */
    @GetMapping
    @Operation(summary = "Get orders by status", description = "Retrieves all orders with a specific status")
    public ResponseEntity<List<OrderResponse>> getOrdersByStatus(
            @RequestParam(required = false) String status) {
        if (status == null || status.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        List<OrderResponse> orders = orderService.getOrdersByStatus(status);
        return ResponseEntity.ok(orders);
    }
    
    /**
     * Delete an order
     * DELETE /api/orders/{id}
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete an order", description = "Deletes an order by its ID")
    public ResponseEntity<Void> deleteOrder(@PathVariable Long id) {
        orderService.deleteOrder(id);
        return ResponseEntity.noContent().build();
    }
}

