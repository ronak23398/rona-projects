import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() async {
    _isLoading = true;
    notifyListeners();
    
    _authService.authStateChanges.listen((AuthState data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _loadCurrentUser();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _currentUser = null;
        _isLoading = false;
        notifyListeners();
      }
    });
    
    // Load current user if already signed in
    if (_authService.currentUser != null) {
      await _loadCurrentUser();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUserProfile();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? mobile,
    String? address,
    String? pincode,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('DEBUG: AuthProvider signUp called');
      print('DEBUG: Email: $email, Role: $role');

      final response = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
        mobile: mobile,
        address: address,
        pincode: pincode,
      );

      print('DEBUG: AuthService response: ${response.user?.id}');
      print('DEBUG: User email: ${response.user?.email}');

      if (response.user != null) {
        print('DEBUG: User created, loading profile...');
        // For new registrations, we might need to wait a moment for the trigger to execute
        await Future.delayed(const Duration(milliseconds: 500));
        await _loadCurrentUser();
        print('DEBUG: Profile loaded after signup: ${_currentUser?.name}');
        return true;
      } else {
        print('DEBUG: No user in signup response');
        _error = 'User registration failed - no user returned';
        return false;
      }
    } catch (e) {
      print('DEBUG: AuthProvider signUp error: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('DEBUG: AuthProvider signIn called with email: $email');
      
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      print('DEBUG: AuthService response: ${response.user?.id}');

      if (response.user != null) {
        print('DEBUG: User authenticated, loading profile...');
        await _loadCurrentUser();
        print('DEBUG: Profile loaded: ${_currentUser?.name}');
        return true;
      } else {
        print('DEBUG: No user in response');
        _error = 'Authentication failed - no user returned';
        return false;
      }
    } catch (e) {
      print('DEBUG: AuthProvider signIn error: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(UserProfile profile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentUser = await _authService.updateProfile(profile);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
