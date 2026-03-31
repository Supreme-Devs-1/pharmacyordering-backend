# 🎉 Pharmacy Ordering Backend - Complete Setup Guide

## ✅ Status: READY TO USE

### 🚀 Application is Running Successfully!

**Server**: http://localhost:8080
**Status**: ✅ Running
**Database**: MySQL (pharmacy)

---

## 📋 What Was Created

### 1. **Cart Endpoints** (✅ Implemented)

#### POST /api/cart/add
- **Description**: Add medicine to cart or update quantity
- **Auth**: Required (JWT)
- **Request Body**:
  ```json
  {
    "medicineId": 1,
    "quantity": 2
  }
  ```

#### GET /api/cart
- **Description**: Retrieve user's shopping cart
- **Auth**: Required (JWT)
- **Returns**: CartResponse with all items and total

#### DELETE /api/cart/remove/{medicineId}
- **Description**: Remove specific medicine from cart
- **Auth**: Required (JWT)
- **Path Params**: medicineId (Long)

#### DELETE /api/cart (Bonus)
- **Description**: Clear entire cart
- **Auth**: Required (JWT)

---

## 📁 Files Created

### Entities
- ✅ `Medicine.java` - Medicine entity
- ✅ `Cart.java` - Shopping cart entity
- ✅ `CartItem.java` - Cart item entity

### Repositories
- ✅ `MedicineRepository.java` - JPA repository for medicines
- ✅ `CartRepository.java` - JPA repository for carts
- ✅ `CartItemRepository.java` - JPA repository for cart items

### Services
- ✅ `CartService.java` - Business logic for cart operations

### Controllers
- ✅ `CartController.java` - REST endpoints for cart operations

### DTOs (Data Transfer Objects)
- ✅ `AddToCartRequest.java` - Request model for adding to cart
- ✅ `CartItemResponse.java` - Response model for cart item
- ✅ `CartResponse.java` - Response model for entire cart

### Database
- ✅ `schema.sql` - Updated with medicines, carts, cart_items tables
- ✅ `data.sql` - Pre-loaded with 8 sample medicines

### Documentation
- ✅ `CART_API_DOCUMENTATION.md` - Complete API documentation
- ✅ `DATABASE_SETUP.md` - Database setup guide
- ✅ `test_cart_api.sh` - Test script for cart endpoints

---

## 🔧 Technology Stack

- **Framework**: Spring Boot 4.0.5
- **Database**: MySQL 8.0+
- **ORM**: Hibernate/JPA
- **Security**: Spring Security + JWT
- **Build**: Maven
- **Java**: JDK 21
- **API Documentation**: Springdoc OpenAPI/Swagger

---

## 🗄️ Database Schema

### medicines table
```sql
CREATE TABLE medicines (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT,
    requires_prescription TINYINT(1),
    dosage VARCHAR(100),
    packaging VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

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

## 📦 Sample Medicines Loaded

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

## 🔐 Security Features

✅ JWT Token-based authentication
✅ Role-based access control (ROLE_USER, ROLE_ADMIN)
✅ All cart endpoints require valid JWT token
✅ Transactional operations with data consistency
✅ Input validation on all endpoints

---

## 🎯 How to Use the API

### 1. Register a User
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test@123"
  }'
```

### 2. Login to Get JWT Token
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "Test@123"
  }'
```

**Response:**
```json
{
  "id": 1,
  "username": "testuser",
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### 3. Add Item to Cart
```bash
TOKEN="eyJhbGciOiJIUzI1NiJ9..."

curl -X POST http://localhost:8080/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 1,
    "quantity": 2
  }'
```

**Response:**
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

### 4. Get Cart
```bash
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

### 5. Remove Item from Cart
```bash
curl -X DELETE http://localhost:8080/api/cart/remove/1 \
  -H "Authorization: Bearer $TOKEN"
```

### 6. Clear Cart
```bash
curl -X DELETE http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

---

## 📚 Available Resources

### Swagger UI
Interactive API documentation:
```
http://localhost:8080/swagger-ui.html
```

### OpenAPI Spec
```
http://localhost:8080/v3/api-docs
```

### User Profile
```
GET http://localhost:8080/api/users/me
```

### Health Check
```
GET http://localhost:8080/api/health
```

---

## 🛠️ Build & Run Commands

### Build Project
```bash
mvn clean install
```

### Run Application
```bash
mvn spring-boot:run
```

### Stop Application
```bash
# Kill process on port 8080
taskkill /F /IM java.exe
```

### Run Tests (if applicable)
```bash
mvn test
```

---

## 📊 Features Implemented

✅ **Add to Cart**
  - Add new medicines
  - Update quantity if already in cart
  - Store price at add time (prevents price changes)

✅ **View Cart**
  - See all items with details
  - Calculate subtotals per item
  - Calculate total cart amount

✅ **Remove Items**
  - Remove specific medicine
  - Remove all items (clear cart)
  - Auto-update total amount

✅ **Data Persistence**
  - All data persisted to MySQL database
  - Transactional operations ensure consistency
  - Automatic timestamps for created/updated dates

✅ **Error Handling**
  - Proper HTTP status codes
  - Meaningful error messages
  - Input validation

✅ **Documentation**
  - Complete API documentation
  - Swagger/OpenAPI integration
  - Code comments and examples

---

## ⚙️ Configuration

### application.properties
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/pharmacy?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=1234
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
```

### Environment Variables (Optional)
```bash
DB_URL=jdbc:mysql://localhost:3306/pharmacy
DB_USERNAME=root
DB_PASSWORD=1234
JWT_SECRET=your-secret-key
JWT_EXPIRATION_MS=3600000
```

---

## 🧪 Testing the Endpoints

### Method 1: Using Swagger UI
1. Navigate to: http://localhost:8080/swagger-ui.html
2. Authenticate with JWT token
3. Try out each endpoint with the "Try it out" button

### Method 2: Using cURL
See examples in "How to Use the API" section above

### Method 3: Using Postman
1. Import the OpenAPI spec: http://localhost:8080/v3/api-docs
2. Add Authorization header with Bearer token
3. Test each endpoint

---

## 📝 Error Codes Reference

| Code | Message | Solution |
|------|---------|----------|
| 400 | Bad Request | Check request body parameters |
| 401 | Unauthorized | Add valid JWT token in Authorization header |
| 404 | Not Found | Check if resource/medicine ID exists |
| 500 | Internal Server Error | Check server logs for details |

---

## 🔄 Workflow Example

```
1. POST /api/auth/register          → Create account
   ↓
2. POST /api/auth/login             → Get JWT token
   ↓
3. GET /api/users/me                → Verify logged in user
   ↓
4. POST /api/cart/add               → Add first medicine
   ↓
5. POST /api/cart/add               → Add another medicine
   ↓
6. GET /api/cart                    → View cart
   ↓
7. DELETE /api/cart/remove/{id}     → Remove item
   ↓
8. GET /api/cart                    → Verify removal
```

---

## 📞 Support & Troubleshooting

### Application Won't Start
- Check if MySQL is running
- Verify database credentials in application.properties
- Check if port 8080 is available

### Database Connection Error
- Ensure MySQL is running
- Verify credentials (default: root/1234)
- Check if 'pharmacy' database exists or can be auto-created

### JWT Token Issues
- Ensure token is in Authorization header as "Bearer <token>"
- Check if token is expired (default: 1 hour)
- Re-login to get a fresh token

### Port Already in Use
```bash
# Kill existing process
taskkill /PID <pid_number> /F
```

---

## 📄 Documentation Files

1. **CART_API_DOCUMENTATION.md** - Full API reference
2. **DATABASE_SETUP.md** - Database configuration guide
3. **README.md** - Project overview
4. **This File** - Complete setup and usage guide

---

## ✨ Next Steps (Recommendations)

1. ✅ Test all cart endpoints using Swagger UI
2. ✅ Create admin dashboard for medicine management
3. ✅ Add order management endpoints
4. ✅ Implement prescription upload functionality
5. ✅ Add payment processing
6. ✅ Create user notifications
7. ✅ Add search and filtering for medicines
8. ✅ Implement inventory management

---

## 📅 Project Details

- **Project Name**: Pharmacy Ordering Backend
- **Version**: 1.0.0
- **Status**: ✅ Ready for Development/Testing
- **Last Updated**: March 31, 2026
- **Java Version**: 21
- **Spring Boot Version**: 4.0.5

---

## 🎊 Summary

Your Pharmacy Ordering Backend is now **fully functional** with:

✅ Complete cart system
✅ All 3 required endpoints + 1 bonus endpoint
✅ Authentication & security
✅ Database integration
✅ API documentation
✅ Sample data
✅ Error handling
✅ Clean code architecture

**The backend is ready for frontend integration!**

---

*For more details, see the individual documentation files in the project root.*

