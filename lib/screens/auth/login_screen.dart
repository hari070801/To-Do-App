import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/resources/widgets.dart';
import 'package:todo_app/screens/home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
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
            SizedBox(height: getWidgetHeight(height: 97)),
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
                      await context.read<AuthProvider>().signIn(emailController.text, passwordController.text);
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
