-- Pharmacy Ordering Database Schema (Design)
-- This file is for schema visibility/versioning; it is not auto-run by Spring Boot.

-- 👤 USERS
CREATE TABLE Users (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PasswordHash VARCHAR(255),
    Role VARCHAR(20), -- CUSTOMER / ADMIN
    Address TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 💊 MEDICINES
CREATE TABLE Medicines (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(150),
    Category VARCHAR(100),
    Price DECIMAL(10,2),
    StockQuantity INT,
    RequiresPrescription TINYINT(1),
    Dosage VARCHAR(100),
    Packaging VARCHAR(100),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 📄 PRESCRIPTIONS
CREATE TABLE Prescriptions (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    FileUrl VARCHAR(255),
    Status VARCHAR(20), -- PENDING / APPROVED / REJECTED
    UploadedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

-- 🛒 ORDERS
CREATE TABLE Orders (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20), -- PLACED / CONFIRMED / SHIPPED / DELIVERED
    PrescriptionId INT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (PrescriptionId) REFERENCES Prescriptions(Id)
);

-- 📦 ORDER ITEMS
CREATE TABLE OrderItems (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    OrderId INT,
    MedicineId INT,
    Quantity INT,
    Price DECIMAL(10,2),

    FOREIGN KEY (OrderId) REFERENCES Orders(Id),
    FOREIGN KEY (MedicineId) REFERENCES Medicines(Id)
);

-- 🎁 LOYALTY POINTS (Stretch)
CREATE TABLE LoyaltyPoints (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    Points INT DEFAULT 0,

    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

-- 🏷️ OFFERS (Stretch)
CREATE TABLE Offers (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150),
    DiscountPercentage INT,
    Category VARCHAR(100),
    ValidTill DATETIME
);
