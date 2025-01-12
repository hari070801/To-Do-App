import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';

class Widgets {
  loginEmailTextField({required TextEditingController emailController}) {
    return Padding(
      padding: EdgeInsets.only(
        top: getWidgetHeight(height: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: getTextSize(fontSize: 16),
              color: appColors.fontColor,
            ),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: getTextSize(fontSize: 16),
              ),
              counterText: '',
              prefixIconConstraints: BoxConstraints(
                maxHeight: getWidgetHeight(height: 50),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 15)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(),
              ),
            ),
          )
        ],
      ),
    );
  }

  loginPassWordTextField({required TextEditingController emailController}) {
    return Padding(
      padding: EdgeInsets.only(
        top: getWidgetHeight(height: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: getTextSize(fontSize: 16),
              color: appColors.fontColor,
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: getTextSize(fontSize: 16),
              ),
              counterText: '',
              prefixIconConstraints: BoxConstraints(
                maxHeight: getWidgetHeight(height: 50),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 15)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(),
              ),
            ),
          )
        ],
      ),
    );
  }

  loginConfirmPassWordTextField({required TextEditingController emailController}) {
    return Padding(
      padding: EdgeInsets.only(
        top: getWidgetHeight(height: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: getTextSize(fontSize: 16),
              color: appColors.fontColor,
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: getTextSize(fontSize: 16),
              ),
              counterText: '',
              prefixIconConstraints: BoxConstraints(
                maxHeight: getWidgetHeight(height: 50),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 15)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget commonBtn({
    required String name,
    required double height,
    required double width,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return Container(
      height: getWidgetHeight(height: height),
      width: getWidgetWidth(width: width),
      decoration: BoxDecoration(
        color: appColors.authBtnColor,
        borderRadius: const BorderRadius.all(Radius.circular(62)),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: getTextSize(fontSize: fontSize),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget showLoader({required Color? color}) {
    if (Platform.isIOS) {
      return Center(
        child: CupertinoActivityIndicator(
          color: color,
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          height: getWidgetHeight(height: 25),
          width: getWidgetWidth(width: 25),
          child: CircularProgressIndicator(
            color: color,
            strokeCap: StrokeCap.round,
            strokeWidth: 2,
          ),
        ),
      );
    }
  }

  static void showFlushBar({required String message, required BuildContext context, Color? color}) async {
    Flushbar(
      message: message,
      backgroundGradient: LinearGradient(
        colors: [
          (color ?? appColors.primaryFlushBar).withOpacity(0.9),
          (color ?? appColors.primaryFlushBar).withOpacity(0.9),
          (color ?? appColors.primaryFlushBar).withOpacity(0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.topRight,
      ),
      messageColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}
