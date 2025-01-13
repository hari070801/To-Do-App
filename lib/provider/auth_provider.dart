import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/resources/auth_service.dart';
import 'package:todo_app/screens/home/home_screen.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthenticationProvider() {
    _authService.user.listen((User? user) {
      _user = user;
      userEmail = _user?.email!;
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
      userEmail = email;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      userEmail = '';

      completedTask.clear();
      notCompletedTask.clear();
      notifyListeners();
    } catch (error) {
      print("Error signing out: $error");
    }
  }
}
