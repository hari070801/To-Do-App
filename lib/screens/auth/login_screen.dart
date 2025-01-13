import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/resources/shared_prefs.dart';
import 'package:todo_app/resources/widgets.dart';
import 'package:todo_app/screens/home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getWidgetHeight(height: 100)),
            Image.asset(
              'assets/images/auth/app-icon.png',
              color: appColors.authBtnColor,
              height: getWidgetHeight(height: 40),
            ),
            SizedBox(height: getWidgetHeight(height: 30)),
            Text(
              'Login',
              style: TextStyle(
                fontSize: getTextSize(fontSize: 30),
                fontWeight: FontWeight.w700,
                color: appColors.authBtnColor,
              ),
            ),
            Widgets().loginEmailTextField(emailController: emailController),
            Widgets().loginPassWordTextField(emailController: passwordController),
            SizedBox(height: getWidgetHeight(height: 20)),
            InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () async {
                  final email = emailController.text.trim();
                  final pwd = passwordController.text.trim();

                  if (email.isEmpty) {
                    Widgets.showFlushBar(message: 'Please enter email', context: context, color: appColors.errorFlushBar);
                  } else if (pwd.isEmpty) {
                    Widgets.showFlushBar(message: 'Please enter password', context: context, color: appColors.errorFlushBar);
                  } else {
                    try {
                      await context.read<AuthenticationProvider>().signIn(emailController.text, passwordController.text);

                      await context.read<TaskProvider>().fetchTasks();

                      saveLoginState();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const HomeScreen();
                        },
                      ));
                    } catch (e) {
                      String errorMessage;

                      // Handling Firebase authentication errors
                      if (e.toString().contains('firebase_auth/invalid-email')) {
                        errorMessage = "The email address is badly formatted.";
                      } else if (e.toString().contains('firebase_auth/user-not-found')) {
                        errorMessage = "No user found with this email. Please check or register.";
                      } else if (e.toString().contains('firebase_auth/wrong-password')) {
                        errorMessage = "The password is incorrect. Please try again.";
                      } else if (e.toString().contains('firebase_auth/email-already-in-use')) {
                        errorMessage = "This email is already registered. Please sign in instead.";
                      } else if (e.toString().contains('firebase_auth/weak-password')) {
                        errorMessage = "The password is too weak. Please use a stronger password.";
                      } else if (e.toString().contains('firebase_auth/user-disabled')) {
                        errorMessage = "This user account has been disabled. Contact support for assistance.";
                      } else if (e.toString().contains('firebase_auth/operation-not-allowed')) {
                        errorMessage = "This operation is not allowed. Please contact support.";
                      } else if (e.toString().contains('firebase_auth/requires-recent-login')) {
                        errorMessage = "This action requires recent authentication. Please sign in again.";
                      } else if (e.toString().contains('firebase_auth/too-many-requests')) {
                        errorMessage = "Too many attempts. Please try again later.";
                      } else if (e.toString().contains('firebase_auth/network-request-failed')) {
                        errorMessage = "Network error. Please check your connection.";
                      }else if (e.toString().contains('firebase_auth/invalid-credential')) {
                        errorMessage = " The supplied auth credential is incorrect, malformed or has expired.";
                      } else {
                        errorMessage = "An unknown error occurred. Please try again later.";
                      }

                      Widgets.showFlushBar(
                        message: errorMessage,
                        context: context,
                        color: appColors.errorFlushBar,
                      );

                      print("Error code: $e");
                    }
                  }
                },
                child: Widgets().commonBtn(name: 'Login', height: 50, width: 357, fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: getWidgetHeight(height: 10)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Text(
                'Create new account',
                style: TextStyle(
                  fontSize: getTextSize(fontSize: 18),
                  color: appColors.fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
