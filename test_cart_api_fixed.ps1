# Pharmacy Ordering Backend - Cart API Debug Test (PowerShell Version)

$BaseUrl = "http://localhost:8080/api"

# Colors
$Green = "Green"
$Blue = "Cyan"
$Red = "Red"
$Yellow = "Yellow"

Write-Host "`n============================================================" -ForegroundColor $Blue
Write-Host "   Pharmacy Ordering Backend - Cart API Debug Test" -ForegroundColor $Blue
Write-Host "============================================================`n" -ForegroundColor $Blue

# Check if server is running
Write-Host "Checking server connectivity..." -ForegroundColor $Yellow
try {
    $serverCheck = Invoke-WebRequest -Uri "$BaseUrl/users/me" -UseBasicParsing -ErrorAction SilentlyContinue
    $statusCode = $serverCheck.StatusCode
} catch {
    $statusCode = $_.Exception.Response.StatusCode.Value
}

Write-Host "Server Response Code: $statusCode"

if ($statusCode -eq 401) {
    Write-Host "[OK] Server is running (401 expected without token)" -ForegroundColor $Green
} else {
    Write-Host "[ERROR] Server is NOT responding correctly!" -ForegroundColor $Red
    Write-Host "Start the server with: mvn spring-boot:run`n"
    exit 1
}

# Step 1: Try to login with existing user
Write-Host "`nStep 1: Attempting to login with existing user..." -ForegroundColor $Blue
$loginBody = @{
    username = "cartuser"
    password = "CartPass123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-WebRequest -Uri "$BaseUrl/auth/login" `
        -Method POST `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $loginBody `
        -UseBasicParsing -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Content

    Write-Host "Login Response: $loginResponse`n"
    $loginJson = $loginResponse | ConvertFrom-Json
    $token = $loginJson.token
} catch {
    $token = $null
}

# If token not found, register and login
if ($null -eq $token) {
    Write-Host "Token not found. Registering new user..." -ForegroundColor $Yellow

    # Step 2: Register new user
    Write-Host "`nStep 2: Registering new test user..." -ForegroundColor $Blue
    $registerBody = @{
        username = "cartuser"
        email    = "cartuser@example.com"
        password = "CartPass123"
    } | ConvertTo-Json

    try {
        $registerResponse = Invoke-WebRequest -Uri "$BaseUrl/auth/register" `
            -Method POST `
            -Headers @{"Content-Type" = "application/json"} `
            -Body $registerBody `
            -UseBasicParsing | Select-Object -ExpandProperty Content

        Write-Host "Register Response: $registerResponse`n"
    } catch {
        Write-Host "Register Error: $($_.Exception.Message)" -ForegroundColor $Red
    }

    # Step 3: Login to get token
    Write-Host "Step 3: Logging in to get JWT token..." -ForegroundColor $Blue
    $loginBody = @{
        username = "cartuser"
        password = "CartPass123"
    } | ConvertTo-Json

    try {
        $loginResponse = Invoke-WebRequest -Uri "$BaseUrl/auth/login" `
            -Method POST `
            -Headers @{"Content-Type" = "application/json"} `
            -Body $loginBody `
            -UseBasicParsing | Select-Object -ExpandProperty Content

        Write-Host "Login Response: $loginResponse`n"
        $loginJson = $loginResponse | ConvertFrom-Json
        $token = $loginJson.token
    } catch {
        Write-Host "Login Error: $($_.Exception.Message)" -ForegroundColor $Red
        exit 1
    }
}

# Check if token was obtained
if ($null -eq $token) {
    Write-Host "[ERROR] Failed to obtain JWT token!" -ForegroundColor $Red
    Write-Host "`nTroubleshooting:" -ForegroundColor $Yellow
    Write-Host "1. Ensure MySQL is running"
    Write-Host "2. Ensure backend is running on port 8080"
    Write-Host "3. Check application.properties for correct database credentials`n"
    exit 1
} else {
    Write-Host "[OK] JWT Token obtained successfully!" -ForegroundColor $Green
    Write-Host "Token: $token`n"
}

# Step 4: Verify user profile
Write-Host "Step 4: Verifying user profile with token..." -ForegroundColor $Blue
try {
    $profileResponse = Invoke-WebRequest -Uri "$BaseUrl/users/me" `
        -Method GET `
        -Headers @{"Authorization" = "Bearer $token"} `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Profile Response: $profileResponse`n"
} catch {
    Write-Host "Profile Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Step 5: Add medicine to cart
Write-Host "Step 5: Adding medicine to cart (ID: 1, Quantity: 2)..." -ForegroundColor $Blue
$addBody = @{
    medicineId = 1
    quantity   = 2
} | ConvertTo-Json

try {
    $addResponse = Invoke-WebRequest -Uri "$BaseUrl/cart/add" `
        -Method POST `
        -Headers @{
            "Authorization" = "Bearer $token"
            "Content-Type"  = "application/json"
        } `
        -Body $addBody `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Add to Cart Response: $addResponse`n"
} catch {
    Write-Host "Add to Cart Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Step 6: Get cart
Write-Host "Step 6: Retrieving cart..." -ForegroundColor $Blue
try {
    $getResponse = Invoke-WebRequest -Uri "$BaseUrl/cart" `
        -Method GET `
        -Headers @{"Authorization" = "Bearer $token"} `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Get Cart Response: $getResponse`n"
} catch {
    Write-Host "Get Cart Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Step 7: Add another medicine
Write-Host "Step 7: Adding another medicine (ID: 3, Quantity: 1)..." -ForegroundColor $Blue
$addBody2 = @{
    medicineId = 3
    quantity   = 1
} | ConvertTo-Json

try {
    $addResponse2 = Invoke-WebRequest -Uri "$BaseUrl/cart/add" `
        -Method POST `
        -Headers @{
            "Authorization" = "Bearer $token"
            "Content-Type"  = "application/json"
        } `
        -Body $addBody2 `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Add Response: $addResponse2`n"
} catch {
    Write-Host "Add Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Step 8: Get updated cart
Write-Host "Step 8: Retrieving updated cart..." -ForegroundColor $Blue
try {
    $getResponse2 = Invoke-WebRequest -Uri "$BaseUrl/cart" `
        -Method GET `
        -Headers @{"Authorization" = "Bearer $token"} `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Get Cart Response: $getResponse2`n"
} catch {
    Write-Host "Get Cart Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Step 9: Remove item
Write-Host "Step 9: Removing medicine from cart (ID: 1)..." -ForegroundColor $Blue
try {
    $deleteResponse = Invoke-WebRequest -Uri "$BaseUrl/cart/remove/1" `
        -Method DELETE `
        -Headers @{"Authorization" = "Bearer $token"} `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Delete Response: $deleteResponse`n"
} catch {
    Write-Host "Delete Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Step 10: Get final cart state
Write-Host "Step 10: Final cart state..." -ForegroundColor $Blue
try {
    $getResponse3 = Invoke-WebRequest -Uri "$BaseUrl/cart" `
        -Method GET `
        -Headers @{"Authorization" = "Bearer $token"} `
        -UseBasicParsing | Select-Object -ExpandProperty Content

    Write-Host "Final Cart: $getResponse3`n"
} catch {
    Write-Host "Get Cart Error: $($_.Exception.Message)" -ForegroundColor $Red
}

Write-Host "============================================================" -ForegroundColor $Green
Write-Host "[SUCCESS] Cart API Testing Complete!" -ForegroundColor $Green
Write-Host "============================================================`n" -ForegroundColor $Green

