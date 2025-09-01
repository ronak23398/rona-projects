# 🛒 Pados Wali Shop - Hyperlocal Marketplace

A Flutter-based hyperlocal marketplace app that connects customers with nearby shops using Supabase as the backend.

## 🚀 Features

### 👥 User Roles
- **Customer**: Browse shops, place orders, track deliveries
- **Shopkeeper**: Manage shop, products, and orders
- **Admin**: Oversee the entire system

### 🔑 Key Functionality
- **Authentication**: Email/password with role-based access
- **Real-time Updates**: Order status tracking with Supabase Realtime
- **Location-based**: Find shops by pincode
- **Smart Delivery**: Free delivery over ₹100, ₹10 charge below
- **Custom Orders**: Text-based orders for unlisted items
- **COD Payment**: Cash on delivery system

## 🛠️ Setup Instructions

### 1. Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Supabase account

### 2. Supabase Setup

#### Create a Supabase Project
1. Go to [supabase.com](https://supabase.com) and create an account
2. Create a new project
3. Note down your project URL and anon key

#### Database Setup
1. In your Supabase dashboard, go to SQL Editor
2. Run the SQL script from `supabase_schema.sql` to create all tables and policies
3. This will create:
   - `profiles` table for user data
   - `shops` table for shop information
   - `products` table for shop inventory
   - `orders` table for order management
   - `order_items` table for order details
   - `custom_orders` table for text-based orders

#### Configure Authentication
1. In Supabase dashboard, go to Authentication > Settings
2. Enable email authentication
3. Configure email templates if needed

### 3. Flutter App Setup

#### Clone and Install Dependencies
```bash
git clone <your-repo-url>
cd pados_wali_shop
flutter pub get
```

#### Configure Supabase Credentials
1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values with your actual Supabase credentials:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_ACTUAL_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_ACTUAL_SUPABASE_ANON_KEY';
}
```

#### Run the App
```bash
flutter run
```

## 📱 App Structure

### Authentication Flow
1. **Splash Screen**: Initial loading
2. **Login/Register**: Role-based registration (Customer/Shopkeeper)
3. **Role-based Navigation**: Automatic redirect based on user role

### Customer Flow
1. Enter pincode to find nearby shops
2. Browse shop products by category
3. Add items to cart
4. Place orders (regular items + custom text orders)
5. Track order status in real-time

### Shopkeeper Flow
1. Create and manage shop profile
2. Add/edit products with images
3. Receive and manage orders
4. Update order status (pending → accepted → out for delivery → delivered)
5. Set custom prices for text-based orders

### Admin Flow
1. View system-wide statistics
2. Manage all shops and users
3. Monitor all orders across the platform
4. User role management

## 🏗️ Architecture

### State Management
- **Provider**: For state management across the app
- **AuthProvider**: User authentication and profile management
- **ShopProvider**: Shop and product management
- **CartProvider**: Shopping cart functionality
- **OrderProvider**: Order management and tracking

### Backend Services
- **AuthService**: Supabase authentication integration
- **ShopService**: Shop and product CRUD operations
- **OrderService**: Order management with real-time updates

### Database Design
- **Row Level Security (RLS)**: Implemented for data security
- **Real-time Subscriptions**: For live order updates
- **Optimized Indexes**: For better query performance

## 🔒 Security Features

- Row Level Security policies for all tables
- Role-based access control
- Secure user authentication
- Data validation at multiple levels

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📋 TODO Features (Future Enhancements)

- [ ] Push notifications for order updates
- [ ] Image upload for products using Supabase Storage
- [ ] GPS-based location services
- [ ] Payment gateway integration
- [ ] Order rating and review system
- [ ] Inventory management alerts
- [ ] Analytics dashboard for shopkeepers
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
1. Check the documentation
2. Review the Supabase setup guide
3. Ensure all environment variables are correctly set
4. Verify database schema is properly created

## 🔧 Troubleshooting

### Common Issues

1. **Supabase Connection Error**
   - Verify URL and anon key in `supabase_config.dart`
   - Check internet connection
   - Ensure Supabase project is active

2. **Authentication Issues**
   - Verify email authentication is enabled in Supabase
   - Check RLS policies are correctly applied
   - Ensure user roles are properly set

3. **Database Errors**
   - Run the complete SQL schema from `supabase_schema.sql`
   - Verify all tables and indexes are created
   - Check RLS policies are active

4. **Build Errors**
   - Run `flutter clean && flutter pub get`
   - Ensure Flutter SDK is up to date
   - Check for any missing dependencies

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
"# rona-projects" 
