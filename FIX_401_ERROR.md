# 🎯 JWT 401 ERROR - Complete Solution

## Your Error
```
Status: 401 Unauthorized
Message: Undocumented
```

This means the API requires authentication but the request doesn't include a valid JWT token.

---

## Why You Got 401

The cart endpoints require JWT authentication:
- `POST /api/cart/add` ← Requires token
- `GET /api/cart` ← Requires token
- `DELETE /api/cart/remove/{medicineId}` ← Requires token

Your request was missing the `Authorization` header with the JWT token.

---

## ✅ SOLUTION

### Step 1: Get JWT Token

```bash
# Register a user
curl -X POST http://localhost:8080/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"Test@123\"}"

# Login to get token
curl -X POST http://localhost:8080/api/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"password\":\"Test@123\"}"
```

You'll get a response like:
```json
{
  "id": 1,
  "username": "testuser",
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0dXNlciIsImlhdCI6MjcwMjAwMDAwMH0.3f..."
}
```

### Step 2: Copy the Token Value
```
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0dXNlciIsImlhdCI6MjcwMjAwMDAwMH0.3f...
```

### Step 3: Use Token in Requests

**NOW INCLUDE THIS IN YOUR REQUEST:**

```bash
# Set token in variable
set TOKEN=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0dXNlciIsImlhdCI6MjcwMjAwMDAwMH0.3f...

# Use it in requests
curl -X GET http://localhost:8080/api/cart ^
  -H "Authorization: Bearer %TOKEN%"
```

**Key Part:** `Authorization: Bearer <your_token>`

---

## Using PowerShell

```powershell
# 1. Login
$response = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type" = "application/json"} `
  -Body '{"username":"testuser","password":"Test@123"}' `
  -UseBasicParsing

# 2. Extract token
$data = $response.Content | ConvertFrom-Json
$token = $data.token

# 3. Use token
Invoke-WebRequest -Uri "http://localhost:8080/api/cart" `
  -Headers @{"Authorization" = "Bearer $token"} `
  -UseBasicParsing
```

---

## Using Swagger UI (EASIEST METHOD)

1. Go to: **http://localhost:8080/swagger-ui.html**

2. Click **"Authorize"** button (lock icon at top right)

3. Enter your token in the field:
   ```
   eyJhbGciOiJIUzI1NiJ9...
   ```

4. Click **"Authorize"**

5. Now click any endpoint and test it!

---

## Test All Endpoints

### Add to Cart (POST)
```bash
curl -X POST http://localhost:8080/api/cart/add ^
  -H "Authorization: Bearer %TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"medicineId\":1,\"quantity\":2}"
```

### Get Cart (GET)
```bash
curl -X GET http://localhost:8080/api/cart ^
  -H "Authorization: Bearer %TOKEN%"
```

### Remove Item (DELETE)
```bash
curl -X DELETE http://localhost:8080/api/cart/remove/1 ^
  -H "Authorization: Bearer %TOKEN%"
```

### Clear Cart (DELETE)
```bash
curl -X DELETE http://localhost:8080/api/cart ^
  -H "Authorization: Bearer %TOKEN%"
```

---

## Common Mistakes

### ❌ WRONG
```bash
# Missing "Bearer"
curl -X GET http://localhost:8080/api/cart ^
  -H "Authorization: %TOKEN%"

# Wrong header name
curl -X GET http://localhost:8080/api/cart ^
  -H "Token: %TOKEN%"

# No token at all
curl -X GET http://localhost:8080/api/cart
```

### ✅ CORRECT
```bash
# Correct format
curl -X GET http://localhost:8080/api/cart ^
  -H "Authorization: Bearer %TOKEN%"
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Register | `POST /api/auth/register` |
| Login (Get Token) | `POST /api/auth/login` |
| Add to Cart | `POST /api/cart/add` (requires token) |
| Get Cart | `GET /api/cart` (requires token) |
| Remove Item | `DELETE /api/cart/remove/{id}` (requires token) |
| Clear Cart | `DELETE /api/cart` (requires token) |

---

## Token Details

- **Format**: JWT (JSON Web Token)
- **Location**: Authorization header
- **Prefix**: Bearer (with space after)
- **Default Expiration**: 1 hour
- **Used By**: All protected endpoints

---

## For Postman Users

1. Go to "Authorization" tab
2. Select "Bearer Token" from dropdown
3. Paste token in "Token" field
4. Send request

---

## For Frontend Developers

Store token from login response:
```javascript
// After login
const token = loginResponse.token;

// Store it
localStorage.setItem('jwtToken', token);

// Use in requests
fetch('http://localhost:8080/api/cart', {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});
```

---

## Running Debug Script

We created a complete test script for you:

```bash
# PowerShell
.\test_cart_api_fixed.ps1

# This will:
# 1. Check server is running
# 2. Register a user (if needed)
# 3. Login and get token
# 4. Test all cart endpoints
# 5. Show responses
```

---

## Database Check

If something still doesn't work:

```bash
# Check MySQL is running
mysql -u root -p

# Check database exists
SHOW DATABASES;

# Check tables
USE pharmacy;
SHOW TABLES;
```

---

## Server Check

```bash
# Port 8080 should be LISTENING
netstat -ano | findstr :8080

# Server logs in console should show:
# "Started PharmacyoderingApplication"
```

---

## Summary

**401 Error = Missing or invalid JWT token**

**Fix = Add this to request:**
```
Authorization: Bearer <your_token>
```

**That's it!** No more 401 errors!

---

## Still Need Help?

1. Read: **TROUBLESHOOTING_401_ERROR.md** (complete guide)
2. Check: **CART_API_DOCUMENTATION.md** (API reference)
3. Try: **test_cart_api_fixed.ps1** (automated test)
4. Visit: http://localhost:8080/swagger-ui.html (interactive testing)

---

**Status**: ✅ Backend is running and ready
**Next**: Get token → Add header → Test endpoint → Done!

