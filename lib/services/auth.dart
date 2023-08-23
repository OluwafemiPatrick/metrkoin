import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices{

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User> get user {
    return _auth.authStateChanges();
  }



  Future<bool> isEmailExist (String email) async {

    final url = 'https://metrkoin.herokuapp.com/verifyEmailAddress?email=$email';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 201) {
      // email does not exist
      return false;
    }
    if (response.statusCode == 200) {
      // email exist
      return true;
    }
    else {
      throw Exception('failed to load data from api');
    }

  }


  Future<bool> createUserAccount (String username, userId, email, refCode, actCreationDate, country) async {

    String parameter = "username=$username&userId=$userId&email=$email&refCode=$refCode"
        "&actDate=$actCreationDate&country=$country";
    final url = 'https://metrkoin.herokuapp.com/createUserAccount?$parameter';

    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      // upload successful
      return true;
    }
    else if (response.statusCode == 400) {
      // upload failed
      return false;
    }

    return false;
  }


  Future<bool> createUserAccountWithRefCode (String username, userId, email, refCode, actCreationDate, country,
      refByCode, refById, refByChain, refByMTRKBal, refByMTRKEarning, refByRefCount, refByRefEarning) async {

    String parameter = "username=$username&userId=$userId&email=$email&refCode=$refCode"
        "&actDate=$actCreationDate&country=$country&refByCode=$refByCode&refById=$refById"
        "&refByChain=$refByChain&refByMTRKBal=$refByMTRKBal&refByMTRKEarning=$refByMTRKEarning"
        "&refByRefCount=$refByRefCount&refByRefEarning=$refByRefEarning";
    final url = 'https://metrkoin.herokuapp.com/createUserAccountWithRefCode?$parameter';

    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      // upload successful
      return true;
    }
    else if (response.statusCode == 400) {
      // upload failed
      return false;
    }

    return false;
  }



  Future<dynamic> verifyReferralCode (String referralCode) async {

    final url = 'https://metrkoin.herokuapp.com/verifyReferralCode?referralCode=$referralCode';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 201) {
      // referral code not valid
      return null;
    }
    if (response.statusCode == 400) {
      // unknown error occurred
      return null;
    }
    else {
      print ('REFERRAL CODE VALID; DETAILS BELOW ' + response.body);
      var data = jsonDecode(response.body);
      return data;
    }

  }


  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      prefs.clear();
      await _auth.signOut();
      await _googleSignIn.signOut();
      return true;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


}