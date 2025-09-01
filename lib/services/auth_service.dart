import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? mobile,
    String? address,
    String? pincode,
  }) async {
    try {
      print('DEBUG: AuthService signUp called');
      print('DEBUG: Email: $email, Role: $role, Name: $name');
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': role,
          'mobile': mobile,
          'address': address,
          'pincode': pincode,
        },
      );

      print('DEBUG: Supabase signUp response: ${response.user?.id}');
      print('DEBUG: User email confirmed: ${response.user?.emailConfirmedAt != null}');

      if (response.user != null) {
        print('DEBUG: Creating profile in profiles table...');
        try {
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'role': role,
            'name': name,
            'email': email,
            'mobile': mobile,
            'address': address,
            'pincode': pincode,
          });
          print('DEBUG: Profile created successfully');
        } catch (profileError) {
          print('DEBUG: Profile creation error: $profileError');
          // Don't rethrow here, as the user might still be created via trigger
        }
      }

      return response;
    } catch (e) {
      print('DEBUG: AuthService signUp error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('DEBUG: AuthService signIn called');
      print('DEBUG: Attempting Supabase authentication...');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      print('DEBUG: Supabase auth response: ${response.user?.id}');
      print('DEBUG: Auth session: ${response.session?.accessToken != null ? "exists" : "null"}');
      
      return response;
    } catch (e) {
      print('DEBUG: AuthService signIn error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) {
        print('DEBUG: No current user found');
        return null;
      }

      print('DEBUG: Current user ID: ${user.id}');
      
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      print('DEBUG: Profile response: $response');
      return UserProfile.fromJson(response);
    } catch (e) {
      print('DEBUG: Error getting user profile: $e');
      return null;
    }
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      final response = await _supabase
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
