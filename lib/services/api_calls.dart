import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:metrkoin/models/account_log/account_log_model.dart';


final String baseUrl = 'https://metrkoin.herokuapp.com/';


Future<dynamic> fetchHomepageData (String userId) async {

  final url = baseUrl + 'getHomepageData?userId=$userId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode==201 || response.statusCode==400) return null;
  else {
    print ('SUCCESS: USER DATA FETCHED => ' + response.body);
    var data = jsonDecode(response.body);
    return data;
  }

}


Future<List<AccountLogModel>?> fetchLogData (String userId) async {

  final url = baseUrl + 'fetchLogData?userId=$userId';
  final response = await http.get(Uri.parse(url));

  if (response==null || response.statusCode==400) return null;
  else if (response != null){
    print (" LOG DATA FETCHED SUCCESSFULLY: " + response.body);

    Iterable list = json.decode(response.body);
    var data = list.map((e) => AccountLogModel.fromJson(e)).toList();
    return data;
  }
}


Future<bool> sendWithdrawalRequest (String userId, amount, timestamp, desc) async {

  final param = 'amount=$amount&userId=$userId&timestamp=$timestamp&description=$desc';
  final url = baseUrl + 'sendWithdrawalRequest?$param';
  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200){
    print ("WITHDRAWAL REQUEST SENT SUCCESSFULLY");
    return true;
  }
  else return false;
}


Future<bool> sendDailyReward (String userId, timestamp, unixTimestamp) async {

  final param = '&userId=$userId&timestamp=$timestamp&unix=$unixTimestamp';
  final url = baseUrl + 'dailyLoginReward?$param';
  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200){
    print ("DAILY REWARD SENT SUCCESSFULLY");
    return true;
  }
  else return false;
}


Future<bool> updateUserBalanceForSudoku (String userId, timestamp, amount) async {

  final param = '&userId=$userId&timestamp=$timestamp&amount=$amount';
  final url = baseUrl + 'updateUserBalanceForSudoku?$param';
  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200){
    print ("SUDOKU REWARD SENT SUCCESSFULLY");
    return true;
  }
  else return false;
}


Future<bool> updateUserBalanceFortyEight (String userId, timestamp, amount) async {

  final param = '&userId=$userId&timestamp=$timestamp&amount=$amount';
  final url = baseUrl + 'updateUserBalanceFortyEight?$param';
  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200){
    print ("2048 REWARD SENT SUCCESSFULLY");
    return true;
  }
  else return false;
}


Future<bool> updateUserBalanceForSlider (String userId, timestamp, amount) async {

  final param = '&userId=$userId&timestamp=$timestamp&amount=$amount';
  final url = baseUrl + 'updateUserBalanceForSlider?$param';
  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200){
    print ("SLIDER REWARD SENT SUCCESSFULLY");
    return true;
  }
  else return false;
}