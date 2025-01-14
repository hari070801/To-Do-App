import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..fetchTasks()),
      ],
      child: MyApp(
        sharedPreferences: prefs,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      kHeight = MediaQuery.of(context).size.height;
      kWidth = MediaQuery.of(context).size.width;
      kTextScale = MediaQuery.of(context).textScaler;
    } else {
      kHeight = MediaQuery.of(context).size.width;
      kWidth = MediaQuery.of(context).size.height;
      kTextScale = MediaQuery.of(context).textScaler;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Figtree',
      ),
      builder: (context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        double scale = (data.devicePixelRatio < 3.0) ? 0.93 : 0.95;

        print("data.size.height : ${data.size.height}");

        if (data.size.height <= 568.0) {
          scale = 0.75;
        } else if (data.size.height <= 667.0) {
          scale = 0.78;
        }

        return MediaQuery(
          data: data.copyWith(
            textScaler: TextScaler.linear(scale),
          ),
          child: child!,
        );
      },
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
