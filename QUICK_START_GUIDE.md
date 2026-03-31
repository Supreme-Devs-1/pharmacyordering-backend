# 🚀 Quick Start Guide - Cart API

## ⚡ 5-Minute Setup

### Prerequisites
- MySQL running on localhost:3306
- Default credentials: root/1234
- Port 8080 available

### Start the Application
```bash
cd "C:\Users\mokes\Downloads\Vijay\pharmacyordering-backend\Downloads\Pharmacyodering"
mvn spring-boot:run
```

✅ **Application is now running at**: http://localhost:8080

---

## 📡 API Endpoints

### 1️⃣ Register User
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","email":"user1@test.com","password":"Pass@123"}'
```

### 2️⃣ Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"Pass@123"}'
```
**Copy the `token` from response**

### 3️⃣ Add to Cart
```bash
TOKEN="your_token_here"

curl -X POST http://localhost:8080/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"medicineId":1,"quantity":2}'
```

### 4️⃣ Get Cart
```bash
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

### 5️⃣ Remove Item
```bash
curl -X DELETE http://localhost:8080/api/cart/remove/1 \
  -H "Authorization: Bearer $TOKEN"
```

### 6️⃣ Clear Cart
```bash
curl -X DELETE http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

---

## 🎯 Available Medicines (Pre-loaded)

| ID | Name | Price |
|----|------|-------|
| 1 | Aspirin | $5.99 |
| 2 | Amoxicillin | $12.50 |
| 3 | Ibuprofen | $8.99 |
| 4 | Vitamin C | $6.99 |
| 5 | Metformin | $15.00 |
| 6 | Lisinopril | $20.00 |
| 7 | Atorvastatin | $18.50 |
| 8 | Omeprazole | $11.99 |

---

## 🧩 Response Example

### Add to Cart Response
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

---

## 🌐 Web Access

### Swagger UI (Interactive API)
```
http://localhost:8080/swagger-ui.html
```

### OpenAPI Spec
```
http://localhost:8080/v3/api-docs
```

---

## 🆘 Troubleshooting

### Port 8080 already in use?
```bash
taskkill /F /IM java.exe
mvn spring-boot:run
```

### MySQL connection error?
```bash
# Check MySQL is running
mysql -u root -p

# Use correct credentials in application.properties
```

### JWT token expired?
```bash
# Re-login to get new token
curl -X POST http://localhost:8080/api/auth/login ...
```

---

## 📋 Implementation Checklist

✅ POST /api/cart/add - Add medicine to cart
✅ GET /api/cart - Retrieve cart
✅ DELETE /api/cart/remove/{medicineId} - Remove item
✅ DELETE /api/cart - Clear cart (bonus)
✅ JWT Authentication
✅ Database schema & tables
✅ Sample data (8 medicines)
✅ Error handling
✅ Swagger documentation

---

## 🔗 File Locations

```
project-root/
├── src/main/java/com/example/pharmacyodering/
│   ├── cart/
│   │   ├── Cart.java
│   │   ├── CartItem.java
│   │   ├── CartService.java
│   │   ├── CartRepository.java
│   │   ├── CartItemRepository.java
│   │   └── dto/
│   │       ├── AddToCartRequest.java
│   │       ├── CartItemResponse.java
│   │       └── CartResponse.java
│   ├── medicine/
│   │   ├── Medicine.java
│   │   └── MedicineRepository.java
│   └── controller/
│       └── CartController.java
├── src/main/resources/
│   ├── schema.sql (Updated)
│   ├── data.sql (Updated)
│   └── application.properties
└── docs/
    ├── COMPLETE_SETUP_GUIDE.md
    ├── CART_API_DOCUMENTATION.md
    ├── DATABASE_SETUP.md
    └── QUICK_START_GUIDE.md (this file)
```

---

## 💡 Tips

1. **Save your JWT token** in a variable for easy testing
2. **Use Swagger UI** for visual API exploration
3. **Test endpoints** in order: Register → Login → Add → Get → Remove
4. **Check logs** if something fails (Maven console)
5. **Refresh Swagger** after code changes (F5)

---

## 🎉 You're All Set!

Backend is running ✅
All endpoints created ✅
Database configured ✅
Sample data loaded ✅
Documentation complete ✅

**Start building your frontend!**

---

For detailed information, see **COMPLETE_SETUP_GUIDE.md**

