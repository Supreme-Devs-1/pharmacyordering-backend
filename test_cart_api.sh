#!/bin/bash

# Script to test the Pharmacy Ordering Backend Cart API

BASE_URL="http://localhost:8080/api"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   Pharmacy Ordering Backend - Cart API Test  ${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Step 1: Register a user
echo -e "${BLUE}1. Registering a test user...${NC}"
REGISTER_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test@123"
  }')

echo "Response: $REGISTER_RESPONSE"
echo -e "\n"

# Step 2: Login to get JWT token
echo -e "${BLUE}2. Logging in to get JWT token...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "Test@123"
  }')

echo "Response: $LOGIN_RESPONSE"

# Extract token
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)
echo -e "${GREEN}Token: $TOKEN${NC}\n"

if [ -z "$TOKEN" ]; then
  echo -e "${RED}Failed to get token. Exiting.${NC}"
  exit 1
fi

# Step 3: Add medicine to cart
echo -e "${BLUE}3. Adding medicine to cart (Medicine ID: 1, Quantity: 2)...${NC}"
ADD_RESPONSE=$(curl -s -X POST "${BASE_URL}/cart/add" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 1,
    "quantity": 2
  }')

echo "Response: $ADD_RESPONSE"
echo -e "\n"

# Step 4: Get cart
echo -e "${BLUE}4. Retrieving cart contents...${NC}"
GET_RESPONSE=$(curl -s -X GET "${BASE_URL}/cart" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $GET_RESPONSE"
echo -e "\n"

# Step 5: Add another medicine to cart
echo -e "${BLUE}5. Adding another medicine to cart (Medicine ID: 3, Quantity: 1)...${NC}"
ADD_RESPONSE2=$(curl -s -X POST "${BASE_URL}/cart/add" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "medicineId": 3,
    "quantity": 1
  }')

echo "Response: $ADD_RESPONSE2"
echo -e "\n"

# Step 6: Get cart again
echo -e "${BLUE}6. Retrieving updated cart...${NC}"
GET_RESPONSE2=$(curl -s -X GET "${BASE_URL}/cart" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $GET_RESPONSE2"
echo -e "\n"

# Step 7: Remove item from cart
echo -e "${BLUE}7. Removing medicine from cart (Medicine ID: 1)...${NC}"
DELETE_RESPONSE=$(curl -s -X DELETE "${BASE_URL}/cart/remove/1" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $DELETE_RESPONSE"
echo -e "\n"

# Step 8: Get cart final state
echo -e "${BLUE}8. Final cart state...${NC}"
GET_RESPONSE3=$(curl -s -X GET "${BASE_URL}/cart" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $GET_RESPONSE3"
echo -e "\n"

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}         Cart API Testing Complete!            ${NC}"
echo -e "${GREEN}================================================${NC}"

