import 'package:flutter/material.dart';
import 'package:metrkoin/screens/authentication/wrapper.dart';
import 'package:metrkoin/screens/homepage/homepage.dart';


void returnToHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    builder: (BuildContext context) => HomePage(),
  ), (route) => false,
  );
}



void returnToWrapperPage(BuildContext context) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    builder: (BuildContext context) => Wrapper(),
  ), (route) => false,
  );
}






