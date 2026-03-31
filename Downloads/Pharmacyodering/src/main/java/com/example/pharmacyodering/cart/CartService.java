package com.example.pharmacyodering.cart;

import com.example.pharmacyodering.cart.dto.AddToCartRequest;
import com.example.pharmacyodering.cart.dto.CartItemResponse;
import com.example.pharmacyodering.cart.dto.CartResponse;
import com.example.pharmacyodering.medicine.Medicine;
import com.example.pharmacyodering.medicine.MedicineRepository;
import com.example.pharmacyodering.user.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final MedicineRepository medicineRepository;

    public CartService(CartRepository cartRepository, CartItemRepository cartItemRepository, MedicineRepository medicineRepository) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.medicineRepository = medicineRepository;
    }

    /**
     * Get or create a cart for a user
     */
    public Cart getOrCreateCart(User user) {
        return cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    return cartRepository.save(newCart);
                });
    }

    /**
     * Add item to cart or update quantity if it exists
     */
    @Transactional
    public CartResponse addToCart(User user, AddToCartRequest request) {
        // Validate request
        if (request.getMedicineId() == null || request.getQuantity() == null || request.getQuantity() <= 0) {
            throw new IllegalArgumentException("Medicine ID and quantity must be valid");
        }

        // Get or create cart
        Cart cart = getOrCreateCart(user);

        // Get medicine
        Medicine medicine = medicineRepository.findById(request.getMedicineId())
                .orElseThrow(() -> new RuntimeException("Medicine not found with ID: " + request.getMedicineId()));

        // Check if item already exists in cart
        Optional<CartItem> existingItem = cartItemRepository.findByCartIdAndMedicineId(cart.getId(), medicine.getId());

        if (existingItem.isPresent()) {
            // Update quantity
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
            cartItemRepository.save(item);
        } else {
            // Add new item
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setMedicine(medicine);
            newItem.setQuantity(request.getQuantity());
            newItem.setPriceAtAddTime(medicine.getPrice());
            cart.addItem(newItem);
        }

        cartRepository.save(cart);
        return buildCartResponse(cart);
    }

    /**
     * Get cart for user
     */
    @Transactional(readOnly = true)
    public CartResponse getCart(User user) {
        Cart cart = getOrCreateCart(user);
        return buildCartResponse(cart);
    }

    /**
     * Remove item from cart
     */
    @Transactional
    public CartResponse removeFromCart(User user, Long medicineId) {
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));

        CartItem item = cartItemRepository.findByCartIdAndMedicineId(cart.getId(), medicineId)
                .orElseThrow(() -> new RuntimeException("Medicine not found in cart"));

        cart.removeItem(item);
        cartItemRepository.delete(item);
        cartRepository.save(cart);

        return buildCartResponse(cart);
    }

    /**
     * Clear cart
     */
    @Transactional
    public void clearCart(User user) {
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        cart.getItems().clear();
        cartRepository.save(cart);
    }

    /**
     * Build cart response
     */
    private CartResponse buildCartResponse(Cart cart) {
        List<CartItemResponse> items = cart.getItems().stream()
                .map(item -> new CartItemResponse(
                        item.getId(),
                        item.getMedicine().getId(),
                        item.getMedicine().getName(),
                        item.getQuantity(),
                        item.getPriceAtAddTime(),
                        item.getSubtotal()
                ))
                .collect(Collectors.toList());

        return new CartResponse(
                cart.getId(),
                items,
                cart.getTotalAmount(),
                items.size()
        );
    }
}

