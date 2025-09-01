-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    role TEXT NOT NULL CHECK (role IN ('admin', 'shopkeeper', 'customer')),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    mobile TEXT,
    address TEXT,
    pincode TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create shops table
CREATE TABLE shops (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    pincode TEXT NOT NULL,
    radius_km INTEGER DEFAULT 5,
    open_status BOOLEAN DEFAULT true,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create products table
CREATE TABLE products (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create orders table
CREATE TABLE orders (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    customer_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,
    delivery_charge NUMERIC(10,2) NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'out_for_delivery', 'delivered', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create order_items table
CREATE TABLE order_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

-- Create custom_orders table
CREATE TABLE custom_orders (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
    description TEXT NOT NULL
);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE custom_orders ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Anyone can insert profile" ON profiles FOR INSERT WITH CHECK (true);
-- Note: This policy should be created separately or removed to avoid recursion
-- CREATE POLICY "Admins can view all profiles" ON profiles FOR SELECT USING (
--     EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
-- );

-- Shops policies
CREATE POLICY "Anyone can view open shops" ON shops FOR SELECT USING (open_status = true);
CREATE POLICY "Shop owners can manage their shops" ON shops FOR ALL USING (owner_id = auth.uid());
-- Note: Admin policies cause recursion - implement via service role or separate logic
-- CREATE POLICY "Admins can view all shops" ON shops FOR SELECT USING (
--     EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
-- );
-- CREATE POLICY "Admins can manage all shops" ON shops FOR ALL USING (
--     EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
-- );

-- Products policies
CREATE POLICY "Anyone can view products from open shops" ON products FOR SELECT USING (
    EXISTS (SELECT 1 FROM shops WHERE id = shop_id AND open_status = true)
);
CREATE POLICY "Shop owners can manage their products" ON products FOR ALL USING (
    EXISTS (SELECT 1 FROM shops WHERE id = shop_id AND owner_id = auth.uid())
);

-- Orders policies
CREATE POLICY "Customers can view their orders" ON orders FOR SELECT USING (customer_id = auth.uid());
CREATE POLICY "Customers can create orders" ON orders FOR INSERT WITH CHECK (customer_id = auth.uid());
CREATE POLICY "Shop owners can view orders for their shops" ON orders FOR SELECT USING (
    EXISTS (SELECT 1 FROM shops WHERE id = shop_id AND owner_id = auth.uid())
);
CREATE POLICY "Shop owners can update orders for their shops" ON orders FOR UPDATE USING (
    EXISTS (SELECT 1 FROM shops WHERE id = shop_id AND owner_id = auth.uid())
);
-- CREATE POLICY "Admins can view all orders" ON orders FOR SELECT USING (
--     EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
-- );

-- Order items policies
CREATE POLICY "Users can view order items for their orders" ON order_items FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM orders 
        WHERE id = order_id 
        AND (customer_id = auth.uid() OR EXISTS (SELECT 1 FROM shops WHERE id = orders.shop_id AND owner_id = auth.uid()))
    )
);
CREATE POLICY "Customers can insert order items" ON order_items FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM orders WHERE id = order_id AND customer_id = auth.uid())
);

-- Custom orders policies
CREATE POLICY "Users can view custom orders for their orders" ON custom_orders FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM orders 
        WHERE id = order_id 
        AND (customer_id = auth.uid() OR EXISTS (SELECT 1 FROM shops WHERE id = orders.shop_id AND owner_id = auth.uid()))
    )
);
CREATE POLICY "Customers can insert custom orders" ON custom_orders FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM orders WHERE id = order_id AND customer_id = auth.uid())
);

-- Create indexes for better performance
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_shops_pincode ON shops(pincode);
CREATE INDEX idx_shops_owner_id ON shops(owner_id);
CREATE INDEX idx_products_shop_id ON products(shop_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_shop_id ON orders(shop_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_custom_orders_order_id ON custom_orders(order_id);

-- Create a function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, name, role)
    VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'name', ''), COALESCE(NEW.raw_user_meta_data->>'role', 'customer'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user registration
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
