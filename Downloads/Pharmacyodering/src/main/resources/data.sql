INSERT IGNORE INTO roles (name) VALUES ('ROLE_USER');
INSERT IGNORE INTO roles (name) VALUES ('ROLE_ADMIN');

-- Sample medicines for testing
INSERT IGNORE INTO medicines (name, category, price, stock_quantity, requires_prescription, dosage, packaging)
VALUES
('Aspirin', 'Pain Relief', 5.99, 100, 0, '500mg', 'Bottle'),
('Amoxicillin', 'Antibiotic', 12.50, 50, 1, '250mg', 'Capsule'),
('Ibuprofen', 'Pain Relief', 8.99, 120, 0, '200mg', 'Tablet'),
('Vitamin C', 'Supplements', 6.99, 200, 0, '1000mg', 'Tablet'),
('Metformin', 'Diabetes', 15.00, 80, 1, '500mg', 'Tablet'),
('Lisinopril', 'Blood Pressure', 20.00, 60, 1, '10mg', 'Tablet'),
('Atorvastatin', 'Cholesterol', 18.50, 75, 1, '20mg', 'Tablet'),
('Omeprazole', 'Digestive', 11.99, 90, 1, '20mg', 'Capsule');

