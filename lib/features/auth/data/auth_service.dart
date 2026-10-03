import 'package:newst/features/auth/data/auth_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
    } on AuthException catch (e) {
      throw AuthError(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
      );
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw AuthError(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthError(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
      );
    }
  }

  Future<UserResponse> updateUserName(String name) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(data: {'name': name}),
      );
    } on AuthException catch (e) {
      throw AuthError(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
      );
    }
  }
}
