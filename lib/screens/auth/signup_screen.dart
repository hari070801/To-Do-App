import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/resources/shared_prefs.dart';
import 'package:todo_app/resources/widgets.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/screens/home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailController;

  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            SizedBox(height: getWidgetHeight(height: 97)),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: getTextSize(fontSize: 30),
                fontWeight: FontWeight.w700,
                color: appColors.authBtnColor,
              ),
            ),
            Widgets().loginEmailTextField(emailController: emailController),
            Widgets().loginPassWordTextField(emailController: passwordController),
            Widgets().loginConfirmPassWordTextField(emailController: confirmPasswordController),
            SizedBox(height: getWidgetHeight(height: 20)),
            InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () async {
                  final email = emailController.text.trim();
                  final pwd = passwordController.text.trim();
                  final conPwd = confirmPasswordController.text.trim();
                  if (email.isEmpty) {
                    Widgets.showFlushBar(message: 'Please enter email', context: context, color: appColors.errorFlushBar);
                  } else if (pwd.isEmpty) {
                    Widgets.showFlushBar(message: 'Please enter password', context: context, color: appColors.errorFlushBar);
                  } else if (conPwd.isEmpty) {
                    Widgets.showFlushBar(message: 'Please enter confirm password', context: context, color: appColors.errorFlushBar);
                  } else if (pwd != conPwd) {
                    Widgets.showFlushBar(message: 'Password and confirm password does not match', context: context, color: appColors.errorFlushBar);
                  } else {
                    try {
                      await context.read<AuthProvider>().signUp(emailController.text, passwordController.text);
                      saveLoginState();
                      Widgets.showFlushBar(message: 'Sign up successful!', context: context);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Widgets().commonBtn(name: 'Sign up', height: 50, width: 357, fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Already have an account',
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
