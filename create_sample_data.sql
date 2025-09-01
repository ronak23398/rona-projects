-- Sample data for testing the shop loading functionality
-- Run this in your Supabase SQL editor to create test data

-- First, let's create some sample users (shopkeepers)
INSERT INTO profiles (id, role, name, email, mobile, address, pincode) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'shopkeeper', 'Raj Kumar', 'raj@example.com', '9876543210', '123 Main Street, Delhi', '110001'),
('550e8400-e29b-41d4-a716-446655440002', 'shopkeeper', 'Priya Sharma', 'priya@example.com', '9876543211', '456 Market Road, Mumbai', '400001'),
('550e8400-e29b-41d4-a716-446655440003', 'shopkeeper', 'Amit Singh', 'amit@example.com', '9876543212', '789 Garden Street, Bangalore', '560001'),
('550e8400-e29b-41d4-a716-446655440004', 'customer', 'Test Customer', 'customer@example.com', '9876543213', '321 Test Street, Delhi', '110001')
ON CONFLICT (id) DO NOTHING;

-- Create sample shops
INSERT INTO shops (owner_id, name, address, pincode, radius_km, open_status) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Raj General Store', '123 Main Street, Connaught Place, Delhi', '110001', 5, true),
('550e8400-e29b-41d4-a716-446655440001', 'Raj Vegetables', '125 Main Street, Connaught Place, Delhi', '110001', 3, true),
('550e8400-e29b-41d4-a716-446655440002', 'Priya Supermarket', '456 Market Road, Andheri, Mumbai', '400001', 7, true),
('550e8400-e29b-41d4-a716-446655440003', 'Amit Fresh Mart', '789 Garden Street, Koramangala, Bangalore', '560001', 4, true),
('550e8400-e29b-41d4-a716-446655440003', 'Amit Pharmacy', '791 Garden Street, Koramangala, Bangalore', '560001', 2, false)
ON CONFLICT DO NOTHING;

-- Get the shop IDs for adding products
-- Note: You'll need to run this after the shops are created to get actual IDs

-- Sample products for the shops
-- This is a template - you'll need to replace the shop_id values with actual IDs from your shops table
/*
INSERT INTO products (shop_id, name, category, price, stock, image_url) VALUES
('your-shop-id-1', 'Rice (1kg)', 'Groceries', 50.00, 100, null),
('your-shop-id-1', 'Dal (1kg)', 'Groceries', 80.00, 50, null),
('your-shop-id-1', 'Onions (1kg)', 'Vegetables', 30.00, 200, null),
('your-shop-id-1', 'Tomatoes (1kg)', 'Vegetables', 40.00, 150, null),
('your-shop-id-2', 'Milk (1L)', 'Dairy', 25.00, 80, null),
('your-shop-id-2', 'Bread', 'Bakery', 20.00, 30, null),
('your-shop-id-2', 'Eggs (12 pcs)', 'Dairy', 60.00, 40, null);
*/

-- Check if data was inserted correctly
SELECT 'Profiles created:' as info, COUNT(*) as count FROM profiles WHERE role IN ('shopkeeper', 'customer');
SELECT 'Shops created:' as info, COUNT(*) as count FROM shops;
SELECT 'Open shops:' as info, COUNT(*) as count FROM shops WHERE open_status = true;
SELECT 'Shops by pincode:' as info, pincode, COUNT(*) as count FROM shops GROUP BY pincode;
