import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:metrkoin/screens/authentication/onboarding_page.dart';
import 'package:metrkoin/screens/homepage/homepage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return OnboardingPage();
    } else {
      return HomePage();
    }
  }
}
