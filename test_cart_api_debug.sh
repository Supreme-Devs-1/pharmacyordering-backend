#!/bin/bash

# Enhanced Cart API Test Script with Debug Output

BASE_URL="http://localhost:8080/api"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Pharmacy Ordering Backend - Cart API Debug Test${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"

# Check if server is running
echo -e "${YELLOW}Checking server connectivity...${NC}"
SERVER_CHECK=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/users/me")
echo -e "Server Response Code: ${SERVER_CHECK}"
if [ "$SERVER_CHECK" = "401" ]; then
    echo -e "${GREEN}✓ Server is running (401 expected without token)${NC}\n"
elif [ "$SERVER_CHECK" = "000" ]; then
    echo -e "${RED}✗ Server is NOT running!${NC}"
    echo -e "Start the server with: mvn spring-boot:run\n"
    exit 1
fi

# Step 1: Check if user already exists, try to login first
echo -e "${BLUE}Step 1: Attempting to login with existing user...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser123",
    "password": "Test@12345"
  }')

echo -e "Login Response: ${LOGIN_RESPONSE}\n"

# Try to extract token
TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo -e "${YELLOW}Token not found in login response. Registering new user...${NC}\n"

    # Step 2: Register a new user
    echo -e "${BLUE}Step 2: Registering new test user...${NC}"
    REGISTER_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register" \
      -H "Content-Type: application/json" \
      -d '{
        "username": "testuser123",
        "email": "test@example.com",
        "password": "Test@12345"
      }')

    echo -e "Register Response: ${REGISTER_RESPONSE}\n"

    # Step 3: Login to get token
    echo -e "${BLUE}Step 3: Logging in to get JWT token...${NC}"
    LOGIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
      -H "Content-Type: application/json" \
      -d '{
        "username": "testuser123",
        "password": "Test@12345"
      }')

    echo -e "Login Response: ${LOGIN_RESPONSE}\n"

    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
fi

# Check if token was obtained
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo -e "${RED}✗ Failed to obtain JWT token!${NC}"
    echo -e "Full response was: ${LOGIN_RESPONSE}\n"
    echo -e "${YELLOW}Troubleshooting:${NC}"
    echo -e "1. Ensure MySQL is running"
    echo -e "2. Ensure backend is running on port 8080"
    echo -e "3. Check application.properties for correct database credentials\n"
    exit 1
else
    echo -e "${GREEN}✓ JWT Token obtained successfully!${NC}"
    echo -e "Token: ${TOKEN}\n"
fi

# Step 4: Verify user profile (test authentication)
echo -e "${BLUE}Step 4: Verifying user profile with token...${NC}"
PROFILE_RESPONSE=$(curl -s -X GET "${BASE_URL}/users/me" \
  -H "Authorization: Bearer ${TOKEN}")

echo -e "Profile Response: ${PROFILE_RESPONSE}\n"

# Step 5: Add medicine to cart
echo -e "${BLUE}Step 5: Adding medicine to cart (ID: 1, Quantity: 2)...${NC}"
ADD_RESPONSE=$(curl -s -X POST "${BASE_URL}/cart/add" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 1,
    "quantity": 2
  }')

echo -e "Add to Cart Response: ${ADD_RESPONSE}\n"

# Step 6: Get cart
echo -e "${BLUE}Step 6: Retrieving cart...${NC}"
GET_RESPONSE=$(curl -s -X GET "${BASE_URL}/cart" \
  -H "Authorization: Bearer ${TOKEN}")

echo -e "Get Cart Response: ${GET_RESPONSE}\n"

# Step 7: Add another medicine
echo -e "${BLUE}Step 7: Adding another medicine (ID: 3, Quantity: 1)...${NC}"
ADD_RESPONSE2=$(curl -s -X POST "${BASE_URL}/cart/add" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 3,
    "quantity": 1
  }')

echo -e "Add Response: ${ADD_RESPONSE2}\n"

# Step 8: Get updated cart
echo -e "${BLUE}Step 8: Retrieving updated cart...${NC}"
GET_RESPONSE2=$(curl -s -X GET "${BASE_URL}/cart" \
  -H "Authorization: Bearer ${TOKEN}")

echo -e "Get Cart Response: ${GET_RESPONSE2}\n"

# Step 9: Remove item
echo -e "${BLUE}Step 9: Removing medicine from cart (ID: 1)...${NC}"
DELETE_RESPONSE=$(curl -s -X DELETE "${BASE_URL}/cart/remove/1" \
  -H "Authorization: Bearer ${TOKEN}")

echo -e "Delete Response: ${DELETE_RESPONSE}\n"

# Step 10: Get final cart state
echo -e "${BLUE}Step 10: Final cart state...${NC}"
GET_RESPONSE3=$(curl -s -X GET "${BASE_URL}/cart" \
  -H "Authorization: Bearer ${TOKEN}")

echo -e "Final Cart: ${GET_RESPONSE3}\n"

echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Cart API Testing Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"

