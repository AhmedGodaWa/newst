import 'package:newst/features/auth/data/auth_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signUp(email: email, password: password);
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

  Session? get currentSession => _supabase.auth.currentSession;
}
