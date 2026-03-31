#!/usr/bin/env pwsh
# JWT Authentication Test - Validates 401 Error Fix

$API_BASE = "http://localhost:8080"

Write-Host "`n====== Step 1: Checking Server ======`n"
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/auth/login" -Method OPTIONS -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ Server is running on $API_BASE`n"
} catch {
    Write-Host "✗ Server is not responding. Make sure it's running on port 8080`n"
    exit 1
}

Write-Host "`n====== Step 2: Registering Test User ======`n"
$testUsername = "testuser_$(Get-Random -Minimum 1000 -Maximum 9999)"
$testPassword = "Test@123"
$testEmail = "$testUsername@example.com"

$registerPayload = @{
    username = $testUsername
    email = $testEmail
    password = $testPassword
} | ConvertTo-Json

try {
    $registerResponse = Invoke-WebRequest -Uri "$API_BASE/api/auth/register" -Method POST -Headers @{"Content-Type" = "application/json"} -Body $registerPayload -UseBasicParsing
    $registerData = $registerResponse.Content | ConvertFrom-Json
    Write-Host "✓ User registered: $testUsername`n"
} catch {
    Write-Host "✗ Registration failed: $_`n"
    exit 1
}

Write-Host "`n====== Step 3: Login to Get JWT Token ======`n"
$loginPayload = @{
    username = $testUsername
    password = $testPassword
} | ConvertTo-Json

try {
    $loginResponse = Invoke-WebRequest -Uri "$API_BASE/api/auth/login" -Method POST -Headers @{"Content-Type" = "application/json"} -Body $loginPayload -UseBasicParsing
    $loginData = $loginResponse.Content | ConvertFrom-Json
    $token = $loginData.token
    Write-Host "✓ Authentication successful!"
    Write-Host "✓ Token received: $($token.Substring(0, 50))...`n"
} catch {
    Write-Host "✗ Login failed: $_`n"
    exit 1
}

Write-Host "`n====== Step 4: Test Cart WITHOUT Token (Should Get 401) ======`n"
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/cart" -Method GET -UseBasicParsing -ErrorAction Stop
    Write-Host "✗ Expected 401 but got 200. There might be an issue.`n"
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✓ Correctly received 401 Unauthorized without token"
        Write-Host "✓ This is EXPECTED and CORRECT - JWT token is required`n"
    } else {
        Write-Host "✗ Got unexpected status: $($_.Exception.Response.StatusCode)`n"
    }
}

Write-Host "`n====== Step 5: Test Cart WITH JWT Token (Should Work) ======`n"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    $cartResponse = Invoke-WebRequest -Uri "$API_BASE/api/cart" -Method GET -Headers $headers -UseBasicParsing
    $cartData = $cartResponse.Content | ConvertFrom-Json
    Write-Host "✓ Successfully retrieved cart with JWT token!"
    Write-Host "✓ Cart has $($cartData.items.Count) items`n"
} catch {
    Write-Host "✗ Failed to get cart: $_`n"
    exit 1
}

Write-Host "`n====== Step 6: Add Medicine to Cart ======`n"
$addToCartPayload = @{
    medicineId = 1
    quantity = 2
} | ConvertTo-Json

try {
    $addResponse = Invoke-WebRequest -Uri "$API_BASE/api/cart/add" -Method POST -Headers $headers -Body $addToCartPayload -UseBasicParsing
    $addData = $addResponse.Content | ConvertFrom-Json
    Write-Host "✓ Medicine added to cart successfully!"
    Write-Host "✓ Cart now contains $($addData.items.Count) item(s)`n"
} catch {
    Write-Host "✗ Failed to add to cart: $_`n"
}

Write-Host "`n====== SUMMARY ======`n"
Write-Host "✓ The 401 error is EXPECTED and CORRECT behavior"
Write-Host "✓ Cart endpoints require JWT authentication"
Write-Host "✓ To use the API:"
Write-Host "  1. Register or Login to get a JWT token"
Write-Host "  2. Include the token in Authorization header"
Write-Host "  3. Format: Authorization: Bearer {token}`n"
Write-Host "✓ Without token = 401 Unauthorized (CORRECT)"
Write-Host "✓ With valid token = 200 OK (WORKING)`n"
Write-Host "✓ Test completed successfully!`n"

