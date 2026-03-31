# 🔧 401 Unauthorized Error - Troubleshooting Guide

## Problem
You're getting a **401 Unauthorized** error when trying to access cart endpoints.

## Root Cause
The API endpoint requires JWT (JSON Web Token) authentication, but:
1. No token was provided in the request, OR
2. The token is invalid/expired, OR
3. The token format is incorrect

---

## Solution Steps

### Step 1: Verify Backend is Running
```bash
# Check if server responds
curl -X GET http://localhost:8080/swagger-ui.html

# You should get HTML response (no error)
```

### Step 2: Get a Valid JWT Token

**Option A: Using the Login Endpoint**
```bash
# 1. First register a user
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "myuser",
    "email": "myuser@example.com",
    "password": "MyPass@123"
  }'

# 2. Then login to get token
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "myuser",
    "password": "MyPass@123"
  }'

# You'll get response like:
# {
#   "id": 1,
#   "username": "myuser",
#   "token": "eyJhbGciOiJIUzI1NiJ9..."
# }
```

**Copy the token value** (the long string after "token":)

### Step 3: Use Token in API Requests

**Correct Way:**
```bash
TOKEN="eyJhbGciOiJIUzI1NiJ9..."

# This will work (401 Fixed!)
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

**Common Mistakes:**
```bash
# ❌ WRONG - No Authorization header
curl -X GET http://localhost:8080/api/cart

# ❌ WRONG - Missing "Bearer" prefix
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: $TOKEN"

# ❌ WRONG - Wrong header name
curl -X GET http://localhost:8080/api/cart \
  -H "Token: Bearer $TOKEN"

# ✅ CORRECT - With Bearer prefix
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"
```

---

## Quick Test Using PowerShell

Run the debug script:
```powershell
.\test_cart_api_debug.ps1
```

This script will:
1. ✅ Check if server is running
2. ✅ Register a new user (if needed)
3. ✅ Login to get JWT token
4. ✅ Test all cart endpoints
5. ✅ Show responses for each step

---

## Using Swagger UI (Easiest Method)

1. **Navigate to**: http://localhost:8080/swagger-ui.html

2. **Authorize with JWT**:
   - Click the "Authorize" button (lock icon)
   - Paste your token: `eyJhbGciOiJIUzI1NiJ9...`
   - Click "Authorize"

3. **Test Endpoints**:
   - Click on each endpoint
   - Click "Try it out"
   - Fill in parameters (medicineId, quantity)
   - Click "Execute"
   - See the response!

---

## Database Connection Issues

If you get errors even with token, check:

### 1. MySQL is Running
```bash
# Check if MySQL is running
mysql -u root -p

# Default credentials from application.properties:
# Username: root
# Password: 1234
```

### 2. Database Exists
```bash
# Login to MySQL
mysql -u root -p

# List databases
SHOW DATABASES;

# Should see: pharmacy (database)

# If not, create it:
CREATE DATABASE IF NOT EXISTS pharmacy;
```

### 3. Connection String
Check `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/pharmacy?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=1234
```

---

## Common Errors & Fixes

### Error: "Cannot resolve reference to bean 'entityManagerFactory'"
**Fix**: Start the server and let it initialize the database
```bash
mvn spring-boot:run
# Wait 10-15 seconds for startup
```

### Error: "Unknown database 'pharmacy'"
**Fix**: Ensure MySQL is running and database auto-creates
```bash
# Or manually create:
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS pharmacy;"
```

### Error: "Access denied for user 'root'@'localhost'"
**Fix**: Check MySQL credentials in application.properties
```properties
spring.datasource.username=root
spring.datasource.password=1234
```

---

## 401 Error Resolution Checklist

- [ ] Backend is running on port 8080
- [ ] Can access Swagger UI (http://localhost:8080/swagger-ui.html)
- [ ] Successfully registered a user
- [ ] Successfully logged in and got JWT token
- [ ] Token is included in request header as: `Authorization: Bearer <token>`
- [ ] MySQL is running
- [ ] Database "pharmacy" exists

---

## Testing Cart Endpoints

Once you have a valid token:

### 1. Add to Cart
```bash
TOKEN="your_token_here"

curl -X POST http://localhost:8080/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 1,
    "quantity": 2
  }'

# Expected: 200 OK with CartResponse
```

### 2. Get Cart
```bash
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"

# Expected: 200 OK with all cart items
```

### 3. Remove Item
```bash
curl -X DELETE http://localhost:8080/api/cart/remove/1 \
  -H "Authorization: Bearer $TOKEN"

# Expected: 200 OK with updated cart
```

### 4. Clear Cart
```bash
curl -X DELETE http://localhost:8080/api/cart \
  -H "Authorization: Bearer $TOKEN"

# Expected: 204 No Content
```

---

## Token Expiration

Default token expiration: **1 hour**

If token expires:
1. Get a new token by logging in again
2. Use the new token in requests

To change expiration, edit `application.properties`:
```properties
jwt.expiration-ms=3600000  # 1 hour in milliseconds
# 7200000 = 2 hours
# 86400000 = 24 hours
```

---

## Still Having Issues?

### 1. Enable Debug Logging
Add to `application.properties`:
```properties
logging.level.root=DEBUG
logging.level.com.example.pharmacyodering=DEBUG
```

### 2. Check Server Logs
Look for messages in the console when server starts:
- "Started PharmacyoderingApplication"
- "Hibernate: CREATE TABLE"
- Any error messages

### 3. Verify Network
```bash
# Check if port 8080 is open
netstat -ano | findstr :8080

# Should show process listening on 8080
```

### 4. Manual Database Check
```bash
# Connect to database
mysql -u root -p -D pharmacy

# Check tables
SHOW TABLES;

# Should show:
# - roles
# - users
# - user_roles
# - medicines
# - carts
# - cart_items
```

---

## Support Resources

- **[QUICK_START_GUIDE.md](../QUICK_START_GUIDE.md)** - Quick setup
- **[CART_API_DOCUMENTATION.md](../CART_API_DOCUMENTATION.md)** - API reference
- **[DATABASE_SETUP.md](../DATABASE_SETUP.md)** - Database config
- **Swagger UI**: http://localhost:8080/swagger-ui.html

---

## Summary

**401 Error means: "You need a valid JWT token"**

Fix:
1. Login to get token
2. Include in header: `Authorization: Bearer <token>`
3. Make request

Done! No more 401 errors! ✅

---

**Still stuck?** Run the debug script:
```bash
./test_cart_api_debug.sh    # Linux/Mac
.\test_cart_api_debug.ps1   # Windows PowerShell
```

This will step through the entire flow and show you exactly where the issue is.

