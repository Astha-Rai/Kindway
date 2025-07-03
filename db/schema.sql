-- USERS TABLE (combined for donor, ngo, and admin roles)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    role ENUM('Donor', 'NGO', 'Admin') NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- LOCATIONS TABLE (for advanced mapping and distance search)
CREATE TABLE Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- CATEGORY TABLE
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- DONATION ITEM TABLE
CREATE TABLE DonationItem (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    category_id INT,
    item_name VARCHAR(100),
    description TEXT,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- DONATION REQUEST TABLE (connects item and ngo)
CREATE TABLE DonationRequest (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    ngo_id INT,
    donation_type ENUM('Pickup', 'Drop-off') NOT NULL,
    status ENUM('Pending', 'Accepted', 'Completed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES DonationItem(item_id) ON DELETE CASCADE,
    FOREIGN KEY (ngo_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- PICKUP REQUEST TABLE
CREATE TABLE PickupRequest (
    pickup_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT,
    pickup_address TEXT,
    preferred_date DATE,
    status ENUM('Requested', 'Scheduled', 'Completed') DEFAULT 'Requested',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES DonationRequest(request_id) ON DELETE CASCADE
);

-- MESSAGE TABLE (threaded)
CREATE TABLE MessageThread (
    thread_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    ngo_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (ngo_id) REFERENCES Users(user_id)
);

CREATE TABLE Message (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    thread_id INT,
    sender_id INT,
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES MessageThread(thread_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id)
);

-- NGO FEEDBACK / RATING
CREATE TABLE NGORating (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    ngo_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (ngo_id) REFERENCES Users(user_id)
);

-- SYSTEM ACTION LOG (for admin auditing)
CREATE TABLE SystemLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT,
    action TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES Users(user_id)
);
-- LOCATION
CREATE TABLE Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- MESSAGE THREAD
CREATE TABLE MessageThread (
    thread_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    ngo_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (ngo_id) REFERENCES Users(user_id)
);

-- NGO RATING
CREATE TABLE NGORating (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    ngo_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (ngo_id) REFERENCES Users(user_id)
);

-- SYSTEM LOG
CREATE TABLE SystemLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT,
    action TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES Users(user_id)
);
