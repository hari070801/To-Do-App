import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double kHeight = 0.0;
double kWidth = 0.0;
TextScaler? kTextScale;

double getWidgetHeight({required double height}) {
  double variableHeightValue = 844 / height;
  return kHeight / variableHeightValue;
}

double getWidgetWidth({required double width}) {
  double variableWidthValue = 390 / width;
  return kWidth / variableWidthValue;
}

double getTextSize({required double fontSize}) {
  return kTextScale!.scale(fontSize);
}
