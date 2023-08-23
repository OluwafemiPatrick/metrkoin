import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:metrkoin/screens/authentication/referral_info.dart';
import 'package:metrkoin/services/auth.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:metrkoin/utils/return_to_home.dart';
import 'package:metrkoin/utils/spinner.dart';
import 'package:metrkoin/utils/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _username = '';
  String _refCode = '';
  String _country = '';
  String bySigningUp = 'By signing up, I agree to the privacy policy and terms of service of MetrKoin';
  String _error = '';
  String _spinnerMssg = '';

  bool _isError = false;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    double inputBoxHeight = 36.0;

    return Scaffold(
      appBar: AppBarWidget(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        color: colorWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 110.0,
                  width: 110.0,
                  child: Image.asset("assets/images/profile_image.png")
                ),
                Spacer(flex: 1),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: Text("Username", style: TextStyle(fontSize: 17.0, color: colorBlack),)),
            SizedBox(
              height: inputBoxHeight,
              child: TextFormField(
                maxLines: 1,
                autofocus: false,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(hintText: "MetrKoin User", hintStyle: TextStyle(fontSize: 14.0)),
                onSaved: (value) => _username = value!.trim(),
                style: TextStyle(fontSize: 14.0),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                    _isError = false;
                  });
                },
              ),
            ),
            if (_isError != false)
              Text(_isError ? 'field is required!' : '', style: TextStyle(color: colorRed, fontSize: 12.0),),
            Container(
                margin: EdgeInsets.only(top: 35.0),
                child: Row(
                  children: [
                    Text("Referral code", style: TextStyle(fontSize: 17.0, color: colorBlack),),
                    SizedBox(width: 6.0,),
                    GestureDetector(
                      child: Icon(Icons.info_outlined, size: 20.0, color: colorPurple,),
                      onTap: () {
                        Get.to(
                          ReferralInfo(),
                          transition: Transition.rightToLeft,
                          duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                        );
                      },
                    )
                  ],
                )),
            SizedBox(
              height: inputBoxHeight,
              child: TextFormField(
                maxLines: 1,
                autofocus: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "hy40hw6M", hintStyle: TextStyle(fontSize: 14.0)),
                onSaved: (value) => _refCode = value!.trim(),
                style: TextStyle(fontSize: 14.0),
                onChanged: (value) {
                  setState(() => _refCode = value );
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 35.0),
                child: Text("Country", style: TextStyle(fontSize: 17.0, color: colorBlack),)),
            SizedBox(
              height: inputBoxHeight,
              child: TextFormField(
                maxLines: 1,
                autofocus: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Nigeria", hintStyle: TextStyle(fontSize: 14.0)),
                onSaved: (value) => _country = value!.trim(),
                style: TextStyle(fontSize: 14.0),
                onChanged: (value) {
                  setState(() {
                    _isError = false;
                    _country = value;
                  });
                },
              ),
            ),
            if (_isError != false)
              Text(_isError ? 'field is required!' : '', style: TextStyle(color: colorRed, fontSize: 12.0),),
            Spacer(flex: 1,),

            _isLoading ? Container(
              child: Column(
                children: [
                  Spinner(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_spinnerMssg, style: TextStyle(fontSize: 13.0,),),
                  )
                ],
              ),
            ) : Container(child: Column(
              children: [
                Text(bySigningUp, style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                SizedBox(height: 10.0,),
                DefaultButtonPurple('Sign up with Google', () async {
                  if (_username.isNotEmpty && _country.isNotEmpty) {
                    setState(() => _isLoading = true);
                    signInFuntions();
                  }
                  else {
                    setState(() => _isError = true);
                  }
                }),
                SizedBox(height: 10.0,),
                if (_error.isNotEmpty)
                  Text(_error,
                    style: TextStyle(fontSize: 13.0, color: colorRed),
                    textAlign: TextAlign.center,),
                SizedBox(height: 10.0,),
              ],
            ),)
          ] )
      ),
    );
  }



  String generateRandomCode(int length) {
    String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnPpQqRrSsTtUuVvWwXxYyZz123456789';
    Random _rnd = Random();

    String rCode = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))
    );
    return rCode;
  }


  Future<User> signInFuntions() async {

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    AuthServices _auth = new AuthServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      setState(() => _spinnerMssg = 'checking device google accounts ...');
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

      // check if google account is already registered
      setState(() => _spinnerMssg = 'verifying email address ...');
      var result = await _auth.isEmailExist(googleSignInAccount.email);

      // if email does not exist, create account
      if (result == false) {

        // did user enter a referral code
        if (_refCode.isNotEmpty) {
          setState(() => _spinnerMssg = 'checking referral code ...');
          var refCodeCheck = await _auth.verifyReferralCode(_refCode);

          // referral code is valid, get referee data and upload user data
          if (refCodeCheck != null) {
            setState(() => _spinnerMssg = 'creating new user account ...');

            String refByCode = refCodeCheck['ref_by_code'].toString();
            String refById = refCodeCheck['ref_by_id'].toString();
            String refByChain = refCodeCheck['ref_by_chain'].toString();
            String refByMTRKBal = refCodeCheck['ref_by_mtrk_bal'].toString();
            String refByMTRKEarning = refCodeCheck['ref_by_mtrk_earning'].toString();
            String refByRefCount = refCodeCheck['ref_by_ref_count'].toString();
            String refByRefEarning = refCodeCheck['ref_by_ref_earning'].toString();

            String userId = generateRandomCode(32);
            prefs.setString('user_id', userId);

            var uploadResult = await _auth.createUserAccountWithRefCode(_username, userId,
                googleSignInAccount.email, generateRandomCode(12), getCurrentDate(), _country, refByCode, refById,
                refByChain, refByMTRKBal, refByMTRKEarning, refByRefCount, refByRefEarning);

            // if server returns 200, complete google auth process
            if (uploadResult == true) {
              setState(() => _spinnerMssg = 'finishing up ...');
              final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
              final AuthCredential credential = GoogleAuthProvider.credential(
                  idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

              UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
              User user = userCredential.user;
              User currentUser = firebaseAuth.currentUser;

              assert(!user.isAnonymous);
              assert(await user.getIdToken() != null);
              assert(currentUser.uid == user.uid);

              returnToWrapperPage(context);
              return user;
            }

            // else tell user to try again
            else if (uploadResult == false) {
              setState(() {
                _error = 'error occurred, please try again';
                _isLoading = false;
              });
              return null;
            }

          }

          // referral code is invalid, ask user to enter it again
          else if (refCodeCheck == null) {
            setState(() {
              _error = 'referral code is invalid, please check and try again';
              _refCode = '';
              _isLoading = false;
            });
            return null;
          }
        }

        // no referral code was entered, upload user data directly
        else {
          setState(() => _spinnerMssg = 'creating new user account ...');
          String userId = generateRandomCode(32);
          prefs.setString('user_id', userId);

          var uploadResult = await _auth.createUserAccount(_username, userId,
              googleSignInAccount.email, generateRandomCode(12), getCurrentDate(), _country);

          // if server returns 200, complete google auth process
          if (uploadResult == true) {
            setState(() => _spinnerMssg = 'finishing up ...');
            final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
                idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

            UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
            User user = userCredential.user;
            User currentUser = firebaseAuth.currentUser;

            assert(!user.isAnonymous);
            assert(await user.getIdToken() != null);
            assert(currentUser.uid == user.uid);

            returnToWrapperPage(context);
            return user;
          }

          // else tell user to try again
          else if (uploadResult == false) {
            setState(() {
              _error = 'error occurred, please try again';
              _isLoading = false;
            });
            return null;
          }
        }
      }

      // email address exist, ask user to sign in instead
      else if (result == true) {
        print ('DUPLICATE EMAIL FOUND, EXITING NOW ...');
        setState(() {
          _isLoading = false;
          _error = 'Email has been registered, please sign in instead';
          _username = '';
          _refCode = '';
          _country = '';
          _spinnerMssg = '';
        });
        return null;
      }
    }

    catch (e) {
      print(e.toString());
      setState(() => _error = e.toString());
      return null;
    }
  }




}
