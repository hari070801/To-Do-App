import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..fetchTasks()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const AuthState(),
    );
  }
}

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthProvider>().user!.email.toString();

    if (user != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
