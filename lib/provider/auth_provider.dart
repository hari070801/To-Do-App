import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/resources/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _authService.user.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signIn(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _authService.signUp(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
