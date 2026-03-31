# 401 Error - Quick Reference & Action Items

## ✅ Problem: RESOLVED

Your 401 Unauthorized error is **NOT A BUG**. It's the **correct security behavior**.

---

## The Issue Explained in 30 Seconds

You were calling `/api/cart` without including a JWT authentication token in the request header.

The server correctly rejected it with **401 Unauthorized**.

---

## Solution: 3 Simple Steps

### Step 1️⃣: Login to Get Token
```
POST http://localhost:8080/api/auth/login

Body:
{
  "username": "admin",
  "password": "admin123"
}

Response:
{
  "id": 1,
  "username": "admin",
  "token": "eyJhbGciOiJIUzI1NiJ9..."  ← SAVE THIS
}
```

### Step 2️⃣: Copy the Token Value
```
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImlhdCI6MTcxNDUxMjEwMCwiZXhwIjoxNzE0NTE1NzAwfQ.abc123...
```

### Step 3️⃣: Include Token in Every Cart Request
```
GET http://localhost:8080/api/cart

Headers:
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

Result: ✅ 200 OK (Works!)
```

---

## Implementation Examples

### Using Swagger UI (Easiest)
1. Go to http://localhost:8080/swagger-ui.html
2. Click "POST /api/auth/login"
3. Enter: `{"username":"admin","password":"admin123"}`
4. Copy token from response
5. Click 🔒 Authorize button
6. Paste: `Bearer <your_token>`
7. Test other endpoints - they now work!

### Using PowerShell
```powershell
# Get token
$auth = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"username":"admin","password":"admin123"}' `
  -UseBasicParsing

$token = ($auth.Content | ConvertFrom-Json).token

# Use token
$headers = @{"Authorization"="Bearer $token"}
Invoke-WebRequest -Uri "http://localhost:8080/api/cart" `
  -Method GET `
  -Headers $headers `
  -UseBasicParsing
```

### Using JavaScript/Fetch
```javascript
// Get token
const authRes = await fetch('http://localhost:8080/api/auth/login', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    username: 'admin',
    password: 'admin123'
  })
});
const authData = await authRes.json();
const token = authData.token;

// Use token
const response = await fetch('http://localhost:8080/api/cart', {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer ' + token
  }
});
const cart = await response.json();
```

---

## Key Points

| What | Answer |
|------|--------|
| **What causes 401?** | Missing or invalid JWT token |
| **Is it a bug?** | No, it's correct security |
| **How to fix?** | Include JWT token in Authorization header |
| **Where get token?** | POST /api/auth/login |
| **What endpoints need token?** | All `/api/cart/*` endpoints |
| **What don't need token?** | /api/auth/register, /api/auth/login |
| **How long is token valid?** | 1 hour (3600000 ms) |

---

## Endpoints Reference

### ✅ No Token Needed (Public)
```
POST /api/auth/register          Register new user
POST /api/auth/login             Login and get token
```

### ❌ Token Required (Protected)
```
GET    /api/cart                 Get shopping cart
POST   /api/cart/add             Add item to cart
DELETE /api/cart/remove/{id}     Remove item
DELETE /api/cart                 Clear cart
GET    /api/auth/profile         Get user profile
```

---

## Common Errors & Fixes

### Error: 401 Unauthorized
```
Cause: Missing token or token in wrong format
Fix: Add header: Authorization: Bearer <token>
```

### Error: 403 Forbidden
```
Cause: Invalid token
Fix: Login again to get new token
```

### Error: 500 Internal Server Error
```
Cause: Server error
Fix: Check database connection and server logs
```

### Token not working
```
Issue: Copy-pasted with extra spaces/quotes
Fix: Make sure exactly: Authorization: Bearer TOKEN
```

---

## Server Configuration

### Start Backend
```bash
cd Downloads/Pharmacyodering
mvn spring-boot:run
```

### Default Credentials
```
Username: admin
Password: admin123
```

### URLs
```
http://localhost:8080/swagger-ui.html       Swagger UI
http://localhost:8080/api/auth/login        Login endpoint
http://localhost:8080/api/cart              Cart endpoint
```

---

## Security Details

### JWT Token Structure
```
Header . Payload . Signature

eyJhbGciOiJIUzI1NiJ9 . eyJzdWIiOiJhZG1pbiIsImlhdCI6MTcxNDUxMjEwMCwiZXhwIjoxNzE0NTE1NzAwfQ . abc123...
```

### Algorithm
```
- Type: HS256 (HMAC with SHA-256)
- Secret: Configured in application.properties
- Expiration: 1 hour (customizable)
```

### Bearer Token Format
```
Authorization: Bearer <jwt_token>

Example:
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImlhdCI6MTcxNDUxMjEwMCwiZXhwIjoxNzE0NTE1NzAwfQ.abc123...
```

---

## Verification Checklist

- ✅ Backend running on http://localhost:8080
- ✅ Can access Swagger UI at http://localhost:8080/swagger-ui.html
- ✅ Can login and get token from /api/auth/login
- ✅ Can add Authorization header to requests
- ✅ Cart endpoints return 200 OK with token
- ✅ Cart endpoints return 401 Unauthorized without token

---

## Documentation Files

| File | Purpose | Read Time |
|------|---------|-----------|
| 401_ERROR_RESOLVED.md | Complete explanation and troubleshooting | 10 min |
| 401_ERROR_COMPLETE_FIX.md | Step-by-step fix with code examples | 5 min |
| CART_API_DOCUMENTATION.md | Full API reference | 15 min |
| FIX_401_ERROR.md | Quick reference guide | 3 min |

---

## TL;DR - The Quick Answer

**Q: Why do I get 401 Unauthorized?**
A: Cart endpoints require JWT authentication. Include token in request header.

**Q: How to fix it?**
A: 
1. Login: POST /api/auth/login with credentials
2. Get token from response
3. Add header: `Authorization: Bearer <token>`
4. Make requests - they now work!

**Q: Is this a bug?**
A: No, this is correct security implementation.

---

## Next: Test It Out

### Option 1: Use Swagger UI (Recommended)
1. Go to http://localhost:8080/swagger-ui.html
2. Click "POST /api/auth/login" → Try it out
3. Enter username and password
4. Click Authorize button (lock icon)
5. Paste token
6. Test /api/cart endpoint

### Option 2: Use Command Line
```powershell
# Run the PowerShell commands in the examples above
```

### Option 3: Integrate Into Your App
```javascript
// Use the JavaScript/Fetch example above
// Modify username/password as needed
```

---

**Status: ✅ FIXED**

Your 401 error is not a bug - it's security working perfectly! 🎉

Follow the 3 steps above and everything will work.

