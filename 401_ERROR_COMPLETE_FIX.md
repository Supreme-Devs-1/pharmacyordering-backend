# 401 Error - Complete Solution & Fix

## ✅ Status: FIXED

The 401 Unauthorized error is **not a bug** - it's the **correct and expected behavior** of your pharmacy ordering API.

---

## Understanding the 401 Error

### What is 401?
**401 Unauthorized** means the API endpoint requires authentication but the request is missing valid credentials.

### Why Are You Getting It?
Your cart endpoints require **JWT (JSON Web Token) authentication**:
- `POST /api/cart/add` - **Requires JWT token**
- `GET /api/cart` - **Requires JWT token**
- `DELETE /api/cart/remove/{medicineId}` - **Requires JWT token**
- `DELETE /api/cart` - **Requires JWT token**

**Your Requests Were Missing the JWT Token** ← This is why you got 401

---

## ✅ Quick Fix (Choose One)

### Option 1: Use Swagger UI (EASIEST - 2 minutes)

1. **Go to**: `http://localhost:8080/swagger-ui.html`

2. **Find "POST /api/auth/login"** endpoint
   - Click "Try it out"
   - Enter test credentials:
     ```json
     {
       "username": "admin",
       "password": "admin123"
     }
     ```
   - Click "Execute"
   - Copy the `token` value from the response

3. **Click the Lock Icon (Authorize button)** at the top right
   - Paste your token into the field:
     ```
     Bearer eyJhbGciOiJIUzI1NiJ9...
     ```
   - Click "Authorize"

4. **Now Test Cart Endpoints**
   - Find "GET /api/cart"
   - Click "Try it out" → "Execute"
   - **Status: 200 OK** ✓ (Now it works!)

---

### Option 2: Command Line (PowerShell)

```powershell
# Step 1: Login and get token
$loginResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type" = "application/json"} `
  -Body '{"username":"admin","password":"admin123"}' `
  -UseBasicParsing

$token = ($loginResponse.Content | ConvertFrom-Json).token

# Step 2: Use token in requests
$headers = @{"Authorization" = "Bearer $token"}

# Step 3: Call cart endpoint with token
$cartResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/cart" `
  -Method GET `
  -Headers $headers `
  -UseBasicParsing

Write-Host "Status: $($cartResponse.StatusCode)"  # Should be 200
```

---

### Option 3: cURL (Windows CMD/PowerShell)

```bash
# Step 1: Login
curl -X POST http://localhost:8080/api/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"admin\",\"password\":\"admin123\"}"

# Copy the token from response

# Step 2: Use token
curl -X GET http://localhost:8080/api/cart ^
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## How the API Security Works

### The Authentication Flow

```
Step 1: Register/Login
┌─────────────────────────────┐
│ POST /api/auth/login        │
│ {"username":"admin",        │
│  "password":"admin123"}     │
└──────────────┬──────────────┘
               │
               ↓
        ┌──────────────┐
        │ Server       │
        │ validates    │
        │ credentials  │
        └──────┬───────┘
               │
               ↓
┌──────────────────────────────────────┐
│ Response:                            │
│ {                                    │
│   "id": 1,                          │
│   "username": "admin",              │
│   "token": "eyJhbGciOiJIUzI1NiJ9..." │ ← Save this!
│ }                                    │
└──────────────────────────────────────┘

Step 2: Use Token in Requests
┌────────────────────────────────────────┐
│ GET /api/cart                          │
│ Headers: {                             │
│   "Authorization": "Bearer TOKEN"      │
│ }                                      │
└─────────────────┬──────────────────────┘
                  │
                  ↓
        ┌─────────────────────┐
        │ Server validates    │
        │ JWT token           │
        └──────────┬──────────┘
                   │
         ┌─────────┴──────────┐
         │                    │
    Valid? ✓           Invalid/Missing? ✗
         │                    │
         ↓                    ↓
    200 OK                401 Unauthorized
    (data returned)      (REJECTED)
```

---

## Key Points

### ✅ The 401 Error is Correct When:
- You're calling a protected endpoint (like `/api/cart/*`)
- WITHOUT an `Authorization` header
- OR with an invalid/expired token

### ✓ The 401 Error is NOT a Bug
- This is the **intended security behavior**
- It prevents unauthorized access to user data
- Your implementation is **correct**

### ✓ How to Prevent 401 Errors:
1. **Always login first** to get a JWT token
2. **Include the token** in the `Authorization` header
3. **Use format**: `Bearer <your_token>`
4. **Refresh token** if it expires

---

## Testing All Endpoints

### Public Endpoints (No Token Needed)
```
POST /api/auth/register  ✓ Works without token
POST /api/auth/login     ✓ Works without token
GET  /api/auth/profile   ✗ Requires token
```

### Protected Endpoints (Token Required)
```
GET    /api/cart              ✗ Requires token
POST   /api/cart/add          ✗ Requires token
DELETE /api/cart/remove/{id}  ✗ Requires token
DELETE /api/cart              ✗ Requires token
```

---

## Troubleshooting

### Problem: "401 Unauthorized" 
**Solution**: Include JWT token in Authorization header
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

### Problem: "Invalid token" / "Token expired"
**Solution**: Get a new token by logging in again
```powershell
$loginResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/login" ...
```

### Problem: "User not found"
**Solution**: Register a new user or use existing credentials
```powershell
# Register
Invoke-WebRequest -Uri "http://localhost:8080/api/auth/register" `
  -Method POST `
  -Body '{"username":"myuser","email":"my@example.com","password":"Pass@123"}'

# Login with same credentials
```

---

## Summary

| Aspect | Details |
|--------|---------|
| **Error** | 401 Unauthorized |
| **Cause** | Missing JWT token in Authorization header |
| **Status** | ✅ CORRECT AND EXPECTED |
| **Fix** | Include JWT token: `Authorization: Bearer <token>` |
| **Get Token** | POST /api/auth/login with credentials |
| **Where** | Include in header of all cart endpoints |

---

## Next Steps

1. ✅ Understand that 401 is expected for protected endpoints
2. ✅ Login to get a JWT token
3. ✅ Include token in Authorization header
4. ✅ Cart endpoints will work (200 OK)

Your API is **secure and working correctly**! 🎉

