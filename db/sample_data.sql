-- ======= USERS =======
INSERT INTO User (name, email, password, phone, location) VALUES 
('Ananya Sharma', 'ananya@example.com', 'pass123', '9999911111', 'Pune'),
('Ravi Kulkarni', 'ravi@example.com', 'pass123', '8888822222', 'Mumbai'),
('Priya Singh', 'priya@example.com', 'pass123', '7777733333', 'Nagpur'),
('Amit Joshi', 'amit@example.com', 'pass123', '6666644444', 'Pune'),
('Sneha Desai', 'sneha@example.com', 'pass123', '9999933333', 'Nashik'),
('Karan Mehta', 'karan@example.com', 'pass123', '9999444411', 'Pune'),
('Divya Patil', 'divya@example.com', 'pass123', '9999222211', 'Mumbai'),
('Rakesh Rathi', 'rakesh@example.com', 'pass123', '9888123456', 'Nagpur'),
('Ishita Jain', 'ishita@example.com', 'pass123', '9898989898', 'Nashik'),
('Deepak Sawant', 'deepak@example.com', 'pass123', '9777722222', 'Thane');

-- ======= DONATION ITEMS =======
INSERT INTO DonationItem (user_id, category_id, item_name, description, image_path) VALUES 
(1, 2, 'Winter Jacket', 'Used but clean winter jacket', '/uploads/jacket.jpg'),
(2, 1, 'Rice Packets', 'Unopened 5kg rice packets', '/uploads/rice.jpg'),
(3, 3, 'School Books', 'Class 10 CBSE books in good condition', '/uploads/books.jpg'),
(4, 5, 'Tulsi Saplings', '5 small tulsi plants', '/uploads/tulsi.jpg'),
(5, 4, 'Old Mobile Phone', 'Working phone with charger', '/uploads/phone.jpg'),
(1, 2, 'Sarees', 'Old but wearable sarees', '/uploads/sarees.jpg'),
(6, 4, 'Old Laptop', 'Dell laptop, works fine, needs battery', '/uploads/laptop.jpg'),
(7, 2, 'Men’s Jeans', '2 pairs, size 34, good condition', '/uploads/jeans.jpg'),
(8, 3, 'Children’s Story Books', '15 books for kids aged 5–8', '/uploads/kids_books.jpg'),
(9, 5, 'Neem Saplings', '4 neem saplings', '/uploads/neem.jpg'),
(10, 1, 'Dry Snacks Packets', '15 sealed packets of mixture', '/uploads/snacks.jpg'),
(6, 1, 'Bread Loaves', '5 fresh loaves from bakery', '/uploads/bread.jpg'),
(3, 2, 'Sweater Bundle', '3 wool sweaters in good condition', '/uploads/sweaters.jpg');

-- ======= DONATION REQUESTS =======
-- NGO IDs: Robin Hood=1, Green India=2, BookSeva=3, Jeevan=4, EcoRecycle=5, Annapurna=6, Sewa Daan=7, TreeSavr=8

INSERT INTO DonationRequest (item_id, ngo_id, donation_type, status) VALUES 
(1, 4, 'Drop-off', 'Completed'),
(2, 1, 'Pickup', 'Accepted'),
(3, 3, 'Drop-off', 'Pending'),
(4, 2, 'Pickup', 'Requested'),
(7, 5, 'Drop-off', 'Accepted'),
(8, 7, 'Pickup', 'Completed'),
(9, 8, 'Pickup', 'Scheduled'),
(10, 6, 'Drop-off', 'Pending'),
(11, 5, 'Drop-off', 'Completed'),
(12, 6, 'Pickup', 'Requested'),
(13, 4, 'Pickup', 'Requested');

-- ======= PICKUP REQUESTS =======
-- Must match request_id values above that used 'Pickup'
-- request_id = row number from DonationRequest where donation_type='Pickup'

INSERT INTO PickupRequest (request_id, pickup_address, preferred_date, status) VALUES 
(2, 'Ravi\'s House, Dadar West, Mumbai', '2025-07-05', 'Scheduled'),
(4, 'Amit\'s Flat, Koregaon Park, Pune', '2025-07-06', 'Requested'),
(6, 'Divya’s Home, Andheri, Mumbai', '2025-07-04', 'Completed'),
(10, 'Deepak’s Apartment, Ghodbunder, Thane', '2025-07-09', 'Requested'),
(11, 'Priya’s House, Hingna, Nagpur', '2025-07-07', 'Requested');

-- ======= MESSAGES =======
INSERT INTO Message (sender_type, sender_id, receiver_id, message) VALUES 
('User', 1, 4, 'Hi, I have some sarees to donate. When can I drop them off?'),
('NGO', 4, 1, 'You can drop them this Saturday at our Nagpur center.'),
('User', 2, 1, 'Can someone pick up the rice packets tomorrow?'),
('NGO', 1, 2, 'Yes, we will schedule a pickup at 11 AM.'),
('User', 7, 5, 'Hi, I have jeans to donate. Can I come today?'),
('NGO', 5, 7, 'Yes, our center is open till 6 PM.'),
('User', 10, 6, 'Can I drop the snacks at your place tomorrow?'),
('NGO', 6, 10, 'Sure, we’ll be available 10am–5pm.'),
('User', 6, 5, 'I also have a few shoes and a torch. Should I add those separately?'),
('NGO', 5, 6, 'You can include them as misc donation. Thank you!');

-- ======= ADMIN =======
INSERT INTO Admin (name, email, password) VALUES 
('Super Admin', 'admin@kindway.org', 'admin123');
