import 'package:flutter/material.dart';

double deviceHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}
double deviceWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}
double statusBarHeight(BuildContext context){
  return MediaQuery.of(context).viewPadding.top;
}