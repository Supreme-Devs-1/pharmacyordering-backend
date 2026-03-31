package com.example.pharmacyodering.order;

import com.example.pharmacyodering.order.dto.CreateOrderRequest;
import com.example.pharmacyodering.order.dto.OrderResponse;
import com.example.pharmacyodering.user.User;
import com.example.pharmacyodering.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class OrderService {
    
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    
    /**
     * Create a new order
     */
    public OrderResponse createOrder(CreateOrderRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with id: " + request.getUserId()));
        
        Order order = new Order();
        order.setUser(user);
        order.setTotalAmount(request.getTotalAmount());
        order.setDescription(request.getDescription());
        order.setStatus("PENDING");
        
        Order savedOrder = orderRepository.save(order);
        return mapToOrderResponse(savedOrder);
    }
    
    /**
     * Get order by ID
     */
    @Transactional(readOnly = true)
    public OrderResponse getOrderById(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
        return mapToOrderResponse(order);
    }
    
    /**
     * Get all orders for a specific user
     */
    @Transactional(readOnly = true)
    public List<OrderResponse> getOrdersByUserId(Long userId) {
        // Verify user exists
        userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        
        List<Order> orders = orderRepository.findByUserId(userId);
        return orders.stream()
                .map(this::mapToOrderResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Update order status
     */
    public OrderResponse updateOrderStatus(Long id, String status) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
        
        // Validate status
        validateOrderStatus(status);
        
        order.setStatus(status);
        Order updatedOrder = orderRepository.save(order);
        return mapToOrderResponse(updatedOrder);
    }
    
    /**
     * Get all orders with a specific status
     */
    @Transactional(readOnly = true)
    public List<OrderResponse> getOrdersByStatus(String status) {
        validateOrderStatus(status);
        List<Order> orders = orderRepository.findByStatus(status);
        return orders.stream()
                .map(this::mapToOrderResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Delete an order
     */
    public void deleteOrder(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
        orderRepository.delete(order);
    }
    
    /**
     * Validate order status
     */
    private void validateOrderStatus(String status) {
        if (!status.matches("^(PENDING|CONFIRMED|SHIPPED|DELIVERED|CANCELLED)$")) {
            throw new RuntimeException("Invalid order status: " + status);
        }
    }
    
    /**
     * Map Order entity to OrderResponse DTO
     */
    private OrderResponse mapToOrderResponse(Order order) {
        OrderResponse response = new OrderResponse();
        response.setId(order.getId());
        response.setUserId(order.getUser().getId());
        response.setUsername(order.getUser().getUsername());
        response.setStatus(order.getStatus());
        response.setTotalAmount(order.getTotalAmount());
        response.setDescription(order.getDescription());
        response.setCreatedAt(order.getCreatedAt());
        response.setUpdatedAt(order.getUpdatedAt());
        return response;
    }
}

