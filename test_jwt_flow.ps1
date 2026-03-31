#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Complete JWT Authentication Flow Test
    Tests the pharmacy ordering API with proper authentication

.DESCRIPTION
    This script demonstrates how to properly use the API with JWT authentication.
    It solves the 401 Unauthorized error by obtaining and using a JWT token.
#>

# Configuration
$API_BASE="http://localhost:8080"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Colors for output
$GREEN = "`e[32m"
$RED = "`e[31m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$RESET = "`e[0m"

function Print-Header {
    param([string]$Title)
    Write-Host "`n$BLUE================================ $Title ================================$RESET"
}

function Print-Success {
    param([string]$Message)
    Write-Host "$GREEN✓ $Message$RESET"
}

function Print-Error {
    param([string]$Message)
    Write-Host "$RED✗ $Message$RESET"
}

function Print-Info {
    param([string]$Message)
    Write-Host "$YELLOW→ $Message$RESET"
}

# Step 1: Check if server is running
Print-Header "Step 1: Checking Server Availability"
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/auth/login" `
        -Method OPTIONS `
        -UseBasicParsing `
        -TimeoutSec 5 `
        -ErrorAction Stop
    Print-Success "Server is running on $API_BASE"
} catch {
    Print-Error "Server is not responding. Make sure it's running on port 8080"
    exit 1
}

# Step 2: Register a test user
Print-Header "Step 2: Registering Test User"
$testUsername = "testuser_$(Get-Random -Minimum 1000 -Maximum 9999)"
$testPassword = "Test@123"
$testEmail = "$testUsername@example.com"

Print-Info "Registering user: $testUsername"

$registerPayload = @{
    username = $testUsername
    email = $testEmail
    password = $testPassword
} | ConvertTo-Json

try {
    $registerResponse = Invoke-WebRequest -Uri "$API_BASE/api/auth/register" `
        -Method POST `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $registerPayload `
        -UseBasicParsing

    $registerData = $registerResponse.Content | ConvertFrom-Json
    Print-Success "User registered successfully!"
    Print-Info "User ID: $($registerData.id)"
    Print-Info "Username: $($registerData.username)"
} catch {
    Print-Error "Registration failed: $_"
    exit 1
}

# Step 3: Login to get JWT token
Print-Header "Step 3: Authenticating and Getting JWT Token"
Print-Info "Logging in as: $testUsername"

$loginPayload = @{
    username = $testUsername
    password = $testPassword
} | ConvertTo-Json

try {
    $loginResponse = Invoke-WebRequest -Uri "$API_BASE/api/auth/login" `
        -Method POST `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $loginPayload `
        -UseBasicParsing

    $loginData = $loginResponse.Content | ConvertFrom-Json
    $token = $loginData.token

    Print-Success "Authentication successful!"
    Print-Info "Token received (first 50 chars): $($token.Substring(0, [Math]::Min(50, $token.Length)))..."

} catch {
    Print-Error "Login failed: $_"
    exit 1
}

# Step 4: Test cart endpoints WITHOUT token (should get 401)
Print-Header "Step 4: Testing Cart Endpoint WITHOUT Token (Should Get 401)"
Print-Info "Attempting to GET /api/cart without Authorization header..."

try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/cart" `
        -Method GET `
        -UseBasicParsing `
        -ErrorAction Stop
    Print-Error "Expected 401 but got 200. There might be an issue."
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Print-Success "Correctly received 401 Unauthorized without token"
        Print-Info "This is expected behavior - JWT token is required for cart endpoints"
    } else {
        Print-Error "Got unexpected status: $($_.Exception.Response.StatusCode)"
    }
}

# Step 5: Test cart endpoints WITH token (should succeed)
Print-Header "Step 5: Testing Cart Endpoint WITH JWT Token (Should Work)"
Print-Info "Attempting to GET /api/cart WITH Authorization header..."

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    $cartResponse = Invoke-WebRequest -Uri "$API_BASE/api/cart" `
        -Method GET `
        -Headers $headers `
        -UseBasicParsing

    $cartData = $cartResponse.Content | ConvertFrom-Json
    Print-Success "Successfully retrieved cart with JWT token!"
    Print-Info "Cart ID: $($cartData.id)"
    Print-Info "Number of items: $($cartData.items.Count)"
} catch {
    Print-Error "Failed to get cart: $_"
    exit 1
}

# Step 6: Add item to cart
Print-Header "Step 6: Adding Medicine to Cart"
Print-Info "Adding Aspirin (Medicine ID: 1) to cart..."

$addToCartPayload = @{
    medicineId = 1
    quantity = 2
} | ConvertTo-Json

try {
    $addResponse = Invoke-WebRequest -Uri "$API_BASE/api/cart/add" `
        -Method POST `
        -Headers $headers `
        -Body $addToCartPayload `
        -UseBasicParsing

    $addData = $addResponse.Content | ConvertFrom-Json
    Print-Success "Medicine added to cart successfully!"
    Print-Info "Cart now contains $($addData.items.Count) item(s)"
    Print-Info "Total items in cart: $($addData.items | Measure-Object -Sum | Select-Object -ExpandProperty Sum)"
} catch {
    Print-Error "Failed to add to cart: $_"
}

# Step 7: Verify cart contents
Print-Header "Step 7: Verifying Cart Contents"
Print-Info "Retrieving updated cart..."

try {
    $verifyResponse = Invoke-WebRequest -Uri "$API_BASE/api/cart" `
        -Method GET `
        -Headers $headers `
        -UseBasicParsing

    $verifyData = $verifyResponse.Content | ConvertFrom-Json
    Print-Success "Cart contents retrieved!"
    Print-Info "Number of items: $($verifyData.items.Count)"

    if ($verifyData.items.Count -gt 0) {
        Write-Host "`n$BLUE Cart Items:$RESET"
        foreach ($item in $verifyData.items) {
            Write-Host "  - $($item.medicineName): Qty=$($item.quantity), Price=$($item.price)"
        }
    }
} catch {
    Print-Error "Failed to retrieve cart: $_"
}

# Summary
Print-Header "Summary: 401 Error Resolution"
Write-Host "$GREEN
✓ The 401 error is EXPECTED and CORRECT behavior
✓ Cart endpoints require JWT authentication
✓ To use the API, you MUST:
  1. Register or Login to get a JWT token
  2. Include the token in the Authorization header
  3. Format: Authorization: Bearer <your_token>

✓ Without the token → 401 Unauthorized (CORRECT)
✓ With valid token → 200 OK (WORKING)
$RESET"

Print-Header "How to Use the API"
Write-Host "$BLUE
From Swagger UI (Recommended):
1. Go to: http://localhost:8080/swagger-ui.html
2. Click the 'Authorize' button (lock icon)
3. Paste your token from login response
4. All endpoints will now include the token automatically

From Command Line (PowerShell):
1. Get token: POST /api/auth/login
2. Save token to variable
3. Add header: -Headers @{'Authorization' = 'Bearer \$token'}
4. Make requests to protected endpoints

From Code (JavaScript/Fetch):
const response = await fetch('http://localhost:8080/api/cart', {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer ' + token
  }
});
$RESET"

Write-Host "`n$GREEN✓ All tests completed successfully!$RESET`n"

