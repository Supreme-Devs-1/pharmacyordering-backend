# 📑 JWT 401 ERROR - COMPLETE REFERENCE

## 🚨 Your Error

```
Status: 401 Unauthorized
Endpoint: /api/cart/*
Reason: Missing JWT Authentication Token
```

---

## ✅ QUICK SOLUTIONS

### 1. Use Swagger UI (Easiest - 2 min)
- Go to: http://localhost:8080/swagger-ui.html
- Test endpoint "POST /api/auth/login"
- Copy token from response
- Click "Authorize" button
- Paste token
- Done! All endpoints now work

### 2. Run Automated Script (1 min)
```bash
.\test_cart_api_fixed.ps1
```
Automatically tests all endpoints with token handling

### 3. Manual Command Line (3 min)
```bash
# Get token
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"Test@123"}'

# Use token
curl -X GET http://localhost:8080/api/cart \
  -H "Authorization: Bearer TOKEN_HERE"
```

---

## 📚 DOCUMENTATION FILES

| File | Size | Purpose | Read Time |
|------|------|---------|-----------|
| **FIX_401_ERROR.md** | 2 KB | Quick fix with examples | 3 min |
| **401_ERROR_ACTION_ITEMS.md** | 2 KB | Actionable checklist | 2 min |
| **TROUBLESHOOTING_401_ERROR.md** | 5 KB | Complete troubleshooting | 10 min |
| **test_cart_api_fixed.ps1** | 3 KB | Automated test script | Run it |
| **CART_API_DOCUMENTATION.md** | 8 KB | Full API reference | 15 min |
| **COMPLETE_SETUP_GUIDE.md** | 15 KB | Complete setup | 20 min |

---

## 🎯 CHOOSE YOUR PATH

### Path 1: I Just Want It Working NOW
→ **FIX_401_ERROR.md** (5 min)  
→ Get token from /api/auth/login  
→ Add to header: `Authorization: Bearer <token>`  
→ Done!

### Path 2: I Want to Understand the Issue
→ **401_ERROR_ACTION_ITEMS.md** (2 min)  
→ **TROUBLESHOOTING_401_ERROR.md** (10 min)  
→ Understand JWT authentication  
→ Implement properly in your code

### Path 3: I Want Complete Reference
→ **FIX_401_ERROR.md** (quick fix)  
→ **TROUBLESHOOTING_401_ERROR.md** (details)  
→ **CART_API_DOCUMENTATION.md** (API)  
→ **COMPLETE_SETUP_GUIDE.md** (full)  
→ Master the backend

### Path 4: I Want Automated Testing
→ Run: **.\test_cart_api_fixed.ps1**  
→ Watch it automatically:
   - Check server
   - Register user
   - Login
   - Get token
   - Test all endpoints

---

## 🔑 KEY CONCEPTS

### JWT Token
- **What**: JSON Web Token for authentication
- **Where**: Authorization header
- **Format**: `Bearer eyJhbGciOiJIUzI1NiJ9...`
- **Duration**: 1 hour (expires after)
- **How to get**: POST /api/auth/login

### How It Works
1. User registers: POST /api/auth/register
2. User logs in: POST /api/auth/login
3. Server returns: JWT token
4. User includes token in requests: `Authorization: Bearer <token>`
5. Server validates token
6. Request proceeds if valid, 401 if invalid

### Why 401 Error
- Endpoint requires authentication
- You didn't include Authorization header
- OR token is invalid/expired
- OR token format is wrong

---

## 🛠️ TROUBLESHOOTING QUICK REFERENCE

| Problem | Solution |
|---------|----------|
| 401 Unauthorized | Add JWT token to Authorization header |
| Token expired | Login again to get new token |
| Invalid token | Copy exact token value, no extra spaces |
| Missing Bearer | Format must be: `Bearer <token>` |
| Wrong header name | Use "Authorization" not "Token" |
| No server response | Ensure server running on port 8080 |
| Database error | Ensure MySQL running with credentials |

---

## 📋 TESTING CHECKLIST

- [ ] Server running on port 8080
- [ ] Can access Swagger UI (http://localhost:8080/swagger-ui.html)
- [ ] Can POST to /api/auth/login
- [ ] Got JWT token from login response
- [ ] Can GET /api/users/me with token
- [ ] Can POST /api/cart/add with token
- [ ] Can GET /api/cart with token
- [ ] Can DELETE /api/cart/remove/{id} with token
- [ ] All endpoints return 200 OK (not 401)
- [ ] Data persists in database

---

## 🎯 NEXT STEPS

### Immediate (Now)
1. Get JWT token from login endpoint
2. Add to Authorization header
3. Test one endpoint
4. Verify 200 OK response

### Short-term (Today)
1. Test all 4 cart endpoints
2. Review API documentation
3. Plan frontend integration
4. Set up token management in frontend

### Long-term (This Week)
1. Implement token storage (localStorage)
2. Handle token expiration
3. Auto-refresh token
4. Integrate complete frontend

---

## 📚 COMPLETE FILE LISTING

```
Project Root:
├── FIX_401_ERROR.md                          ← START HERE!
├── 401_ERROR_ACTION_ITEMS.md                 ← Quick checklist
├── TROUBLESHOOTING_401_ERROR.md              ← Deep dive
├── test_cart_api_fixed.ps1                   ← Run this
├── CART_API_DOCUMENTATION.md                 ← API reference
├── COMPLETE_SETUP_GUIDE.md                   ← Full guide
├── DOCUMENTATION_INDEX.md                    ← Doc navigation
├── QUICK_START_GUIDE.md                      ← Quick setup
├── DATABASE_SETUP.md                         ← DB config
├── README.md                                 ← Project info
└── COMPLETION_SUMMARY.md                     ← Summary
```

---

## 💡 IMPORTANT NOTES

1. **This is NOT a bug** - 401 is expected without token
2. **This is SECURITY** - Protecting endpoints is good!
3. **This is NORMAL** - All APIs require authentication
4. **This is EASY** - Just add token to header

---

## 🎓 LEARNING RESOURCES

### Understand JWT
- JWT consists of 3 parts separated by dots: `header.payload.signature`
- Token is created on login
- Token proves you are authenticated
- Token expires after set time (default 1 hour)
- Always include "Bearer " prefix before token

### Understand REST Security
- GET/POST/PUT/DELETE require authentication
- Authentication done via headers
- Authorization header carries credentials
- Server validates before processing request

### Understand Your API
- /api/auth/register - Create account (no token needed)
- /api/auth/login - Get token (no token needed)
- /api/users/me - Profile (token required)
- /api/cart/* - Cart operations (token required)

---

## 🔗 QUICK LINKS

**For Immediate Fix**: [FIX_401_ERROR.md](FIX_401_ERROR.md)  
**For Details**: [TROUBLESHOOTING_401_ERROR.md](TROUBLESHOOTING_401_ERROR.md)  
**For Testing**: Run `.\test_cart_api_fixed.ps1`  
**For API**: [CART_API_DOCUMENTATION.md](CART_API_DOCUMENTATION.md)  
**For Full Info**: [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md)  

**Live Testing**: http://localhost:8080/swagger-ui.html

---

## ✨ SUMMARY

| What | Details |
|------|---------|
| **Problem** | 401 Unauthorized when calling /api/cart |
| **Cause** | Missing JWT authentication token |
| **Solution** | Add token to Authorization header |
| **Time to Fix** | 2 minutes |
| **Complexity** | Very Simple |
| **Status** | ✅ Ready to use |

---

**Choose your starting point above and follow the path that matches your needs!**

All files are in the project root directory.

**Most Common Next Step**: Read [FIX_401_ERROR.md](FIX_401_ERROR.md)

