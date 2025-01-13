import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginState() async {
  print("login data saved");
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  print("isLoggedIn : $isLoggedIn");
}

Future<void> clearLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');
}
