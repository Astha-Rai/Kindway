-- ========== DONATION REQUESTS ==========
INSERT INTO DonationRequest (item_id, ngo_id, donation_type, status) VALUES 
(15, 4, 'Drop-off', 'Completed'),
(16, 1, 'Pickup', 'Accepted'),
(17, 3, 'Drop-off', 'Pending'),
(18, 2, 'Pickup', 'Pending'),
(21, 5, 'Drop-off', 'Accepted'),
(22, 7, 'Pickup', 'Completed'),
(23, 8, 'Pickup', 'Accepted'),
(24, 6, 'Drop-off', 'Pending'),
(25, 5, 'Drop-off', 'Completed'),
(26, 6, 'Pickup', 'Pending'),
(27, 4, 'Pickup', 'Pending');

-- ========== PICKUP REQUESTS ==========
-- Ensure request_ids match the Pickup donation_type rows above
-- Only valid statuses: 'Requested', 'Accepted', 'Completed'

INSERT INTO PickupRequest (request_id, pickup_address, preferred_date, status) VALUES 
(16, 'Ravi\'s House, Dadar West, Mumbai', '2025-07-05', 'Accepted'),
(18, 'Amit\'s Flat, Koregaon Park, Pune', '2025-07-06', 'Requested'),
(22, 'Divya’s Home, Andheri, Mumbai', '2025-07-04', 'Completed'),
(23, 'Deepak’s Apartment, Ghodbunder, Thane', '2025-07-09', 'Requested'),
(26, 'Priya’s House, Hingna, Nagpur', '2025-07-07', 'Requested'),
(27, 'Ritu’s House, Baner, Pune', '2025-07-08', 'Accepted');
