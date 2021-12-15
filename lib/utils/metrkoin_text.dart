import 'package:flutter/material.dart';
import 'package:metrkoin/utils/colors.dart';

Widget MetrKoinText(double height, width) {
  return  Container(
    height: height,
    width: width!=0.0 ? width : 85.0,
    color: colorWhite,
    padding: EdgeInsets.symmetric(vertical: 5.0),
    child: Image.asset("assets/images/metrkoin120.png")
  );
}