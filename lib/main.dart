import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/customer_home_screen.dart';
import 'screens/shopkeeper/shopkeeper_home_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const PadosWaliShopApp());
}

class PadosWaliShopApp extends StatelessWidget {
  const PadosWaliShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'Pados Wali Shop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            routerConfig: _createRouter(authProvider),
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final currentUser = authProvider.currentUser;
        final isLoading = authProvider.isLoading;
        final location = state.uri.toString();
        
        // If still loading, stay on splash screen
        if (isLoading) {
          return location == '/splash' ? null : '/splash';
        }
        
        // If not authenticated and not on auth screens, go to login
        if (!isAuthenticated && 
            !location.startsWith('/login') && 
            !location.startsWith('/register')) {
          return '/login';
        }
        
        // If authenticated and on auth screens or splash, redirect based on role
        if (isAuthenticated && 
            (location.startsWith('/login') || 
             location.startsWith('/register') ||
             location == '/splash')) {
          switch (currentUser?.role) {
            case 'customer':
              return '/customer';
            case 'shopkeeper':
              return '/shopkeeper';
            case 'admin':
              return '/admin';
            default:
              return '/login';
          }
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/customer',
          builder: (context, state) => const CustomerHomeScreen(),
        ),
        GoRoute(
          path: '/shopkeeper',
          builder: (context, state) => const ShopkeeperHomeScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminHomeScreen(),
        ),
      ],
    );
  }
}
