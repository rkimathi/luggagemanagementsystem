-- Database creation
DROP DATABASE IF EXISTS luggage_storage;
CREATE DATABASE luggage_storage;
USE luggage_storage;

-- Customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    id_type VARCHAR(20) NOT NULL,
    id_number VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uc_customer_id UNIQUE (id_type, id_number)
);

-- Storage locations table
CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    capacity INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Luggage items table
CREATE TABLE luggage_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    storage_date DATETIME NOT NULL,
    retrieval_date DATETIME NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    dimensions VARCHAR(50) NOT NULL,
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT FALSE,
    is_valuable BOOLEAN DEFAULT FALSE,
    status ENUM('stored', 'retrieved', 'lost') DEFAULT 'stored',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CHECK (retrieval_date > storage_date)
);

-- Storage assignments table (M-M relationship between luggage and locations)
CREATE TABLE storage_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    location_id INT NOT NULL,
    locker_number VARCHAR(20) NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES luggage_items(item_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    CONSTRAINT uc_locker_assignment UNIQUE (location_id, locker_number)
);

-- Staff table
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    location_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Payments table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('cash', 'credit_card', 'debit_card', 'mobile_payment') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_id VARCHAR(100),
    status ENUM('pending', 'completed', 'refunded') DEFAULT 'completed',
    FOREIGN KEY (item_id) REFERENCES luggage_items(item_id)
);

-- Insurance options table
CREATE TABLE insurance_options (
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    coverage_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    daily_rate DECIMAL(6,2) NOT NULL,
    max_coverage DECIMAL(10,2) NOT NULL
);

-- Luggage insurance table (M-M relationship between luggage and insurance)
CREATE TABLE luggage_insurance (
    insurance_record_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    insurance_id INT NOT NULL,
    coverage_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (item_id) REFERENCES luggage_items(item_id),
    FOREIGN KEY (insurance_id) REFERENCES insurance_options(insurance_id)
);

-- Audit log table
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action ENUM('insert', 'update', 'delete') NOT NULL,
    action_by INT,
    action_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_values JSON,
    new_values JSON,
    FOREIGN KEY (action_by) REFERENCES staff(staff_id)
);

-- Create indexes for better performance
CREATE INDEX idx_customer_name ON customers(last_name, first_name);
CREATE INDEX idx_luggage_dates ON luggage_items(storage_date, retrieval_date);
CREATE INDEX idx_luggage_status ON luggage_items(status);
CREATE INDEX idx_payment_status ON payments(status);
