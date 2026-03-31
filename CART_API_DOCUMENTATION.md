# Cart API Documentation

## Overview
The Cart API provides endpoints for managing shopping carts in the Pharmacy Ordering system. Users can add medicines to their cart, view cart contents, and remove items.

## Base URL
```
http://localhost:8080/api/cart
```

## Authentication
All endpoints require JWT authentication. Include the bearer token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### 1. Add Medicine to Cart
**POST** `/api/cart/add`

Add a medicine to the user's cart or increase quantity if it already exists.

**Request Body:**
```json
{
  "medicineId": 1,
  "quantity": 2
}
```

**Parameters:**
- `medicineId` (Long, required): The ID of the medicine to add
- `quantity` (Integer, required): Number of units to add (must be > 0)

**Response (200 OK):**
```json
{
  "cartId": 1,
  "items": [
    {
      "id": 1,
      "medicineId": 1,
      "medicineName": "Aspirin",
      "quantity": 2,
      "priceAtAddTime": 5.99,
      "subtotal": 11.98
    }
  ],
  "totalAmount": 11.98,
  "itemCount": 1
}
```

**Error Responses:**
- `400 Bad Request`: Invalid medicine ID or quantity
- `404 Not Found`: Medicine not found
- `401 Unauthorized`: Missing or invalid JWT token

---

### 2. Get Cart
**GET** `/api/cart`

Retrieve the current user's shopping cart with all items.

**Request:**
```
GET /api/cart
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "cartId": 1,
  "items": [
    {
      "id": 1,
      "medicineId": 1,
      "medicineName": "Aspirin",
      "quantity": 2,
      "priceAtAddTime": 5.99,
      "subtotal": 11.98
    },
    {
      "id": 2,
      "medicineId": 3,
      "medicineName": "Ibuprofen",
      "quantity": 1,
      "priceAtAddTime": 8.99,
      "subtotal": 8.99
    }
  ],
  "totalAmount": 20.97,
  "itemCount": 2
}
```

**Error Responses:**
- `401 Unauthorized`: Missing or invalid JWT token
- `500 Internal Server Error`: Server error

---

### 3. Remove Medicine from Cart
**DELETE** `/api/cart/remove/{medicineId}`

Remove a specific medicine from the user's cart.

**Request:**
```
DELETE /api/cart/remove/1
Authorization: Bearer <token>
```

**Path Parameters:**
- `medicineId` (Long, required): The ID of the medicine to remove

**Response (200 OK):**
```json
{
  "cartId": 1,
  "items": [
    {
      "id": 2,
      "medicineId": 3,
      "medicineName": "Ibuprofen",
      "quantity": 1,
      "priceAtAddTime": 8.99,
      "subtotal": 8.99
    }
  ],
  "totalAmount": 8.99,
  "itemCount": 1
}
```

**Error Responses:**
- `401 Unauthorized`: Missing or invalid JWT token
- `404 Not Found`: Cart or medicine not found in cart

---

### 4. Clear Cart (Bonus Endpoint)
**DELETE** `/api/cart`

Remove all items from the user's cart.

**Request:**
```
DELETE /api/cart
Authorization: Bearer <token>
```

**Response (204 No Content)**
Empty response body

**Error Responses:**
- `401 Unauthorized`: Missing or invalid JWT token
- `404 Not Found`: Cart not found

---

## Data Models

### AddToCartRequest
```json
{
  "medicineId": "Long",
  "quantity": "Integer"
}
```

### CartItemResponse
```json
{
  "id": "Long",
  "medicineId": "Long",
  "medicineName": "String",
  "quantity": "Integer",
  "priceAtAddTime": "BigDecimal",
  "subtotal": "BigDecimal"
}
```

### CartResponse
```json
{
  "cartId": "Long",
  "items": "[CartItemResponse]",
  "totalAmount": "BigDecimal",
  "itemCount": "Integer"
}
```

---

## Available Medicines

The system comes pre-loaded with the following medicines:

| ID | Name | Category | Price | Requires Rx |
|----|------|----------|-------|------------|
| 1 | Aspirin | Pain Relief | $5.99 | No |
| 2 | Amoxicillin | Antibiotic | $12.50 | Yes |
| 3 | Ibuprofen | Pain Relief | $8.99 | No |
| 4 | Vitamin C | Supplements | $6.99 | No |
| 5 | Metformin | Diabetes | $15.00 | Yes |
| 6 | Lisinopril | Blood Pressure | $20.00 | Yes |
| 7 | Atorvastatin | Cholesterol | $18.50 | Yes |
| 8 | Omeprazole | Digestive | $11.99 | Yes |

---

## Example Usage

### Step 1: Register and Login (Get JWT Token)
```bash
# Register
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "Password@123"
  }'

# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "Password@123"
  }'
```

### Step 2: Add Items to Cart
```bash
TOKEN="your_jwt_token_here"

# Add Aspirin (quantity: 2)
curl -X POST http://localhost:8080/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 1,
    "quantity": 2
  }'

# Add Ibuprofen (quantity: 1)
curl -X POST http://localhost:8080/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 3,
    "quantity": 1
  }'
```

### Step 3: View Cart
```bash
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

### Step 4: Remove Item
```bash
# Remove Aspirin
curl -X DELETE http://localhost:8080/api/cart/remove/1 \
  -H "Authorization: Bearer $TOKEN"
```

### Step 5: Clear Cart
```bash
curl -X DELETE http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

---

## Features

✅ **Add to Cart**: Add medicines with quantity or update existing items
✅ **View Cart**: See all items with prices and subtotals
✅ **Remove Items**: Delete specific medicines from cart
✅ **Clear Cart**: Remove all items at once
✅ **Price Tracking**: Prices are locked when items are added
✅ **JWT Security**: All endpoints require authentication
✅ **Automatic Subtotals**: Calculate item subtotals (quantity × price)
✅ **Total Calculation**: Automatic cart total calculation

---

## Error Handling

All errors return appropriate HTTP status codes:

| Status Code | Meaning |
|------------|---------|
| 200 | OK - Request succeeded |
| 204 | No Content - Successful deletion |
| 400 | Bad Request - Invalid parameters |
| 401 | Unauthorized - Missing or invalid JWT token |
| 404 | Not Found - Resource not found |
| 500 | Internal Server Error - Server error |

---

## Best Practices

1. **Always authenticate**: Include JWT token in all requests
2. **Validate quantity**: Ensure quantity > 0 before adding
3. **Handle errors**: Check response status codes and error messages
4. **Cache cart data**: Consider caching cart on client side
5. **Refresh after updates**: Refresh cart after adding/removing items
6. **Session management**: Keep JWT token fresh and valid

---

## Swagger Documentation

Access the interactive API documentation at:
```
http://localhost:8080/swagger-ui.html
```

All cart endpoints are documented with detailed descriptions and try-it-out functionality.

---

## Database Schema

### carts table
```sql
CREATE TABLE carts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users (id)
);
```

### cart_items table
```sql
CREATE TABLE cart_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    medicine_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price_at_add_time DECIMAL(10,2),
    CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts (id),
    CONSTRAINT fk_cart_items_medicine FOREIGN KEY (medicine_id) REFERENCES medicines (id)
);
```

---

## Support

For issues or questions, please refer to the API documentation or contact the development team.

Last Updated: March 31, 2026
API Version: 1.0

