import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metrkoin/services/auth.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'screens/authentication/wrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthServices().user,
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MetrKoin',
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: colorWhite,
            accentColor: colorWhite,
          ),
          home: SplashScreen(),

      ),
    );
  }
}


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer timer;

  @override
  void initState() {
    timer = new Timer(
        Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Wrapper()));
    } );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(backgroundColor: colorWhite)
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorWhite,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset('assets/icons/metrkoin.png'),
                ),
                SizedBox(height: 20.0,),
                Container(
                  width: 140.0,
                  child: Image.asset('assets/images/metrkoin120.png'),
                ),
                SizedBox(height: 20.0,),
              ] ),
        ),
      ),
    );

  }
}
