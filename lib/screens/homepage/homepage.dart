import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metrkoin/screens/account_log/account_log.dart';
import 'package:metrkoin/screens/game_arena/game_arena.dart';
import 'package:metrkoin/screens/homepage/calculator.dart';
import 'package:metrkoin/screens/homepage/drawer_items.dart';
import 'package:metrkoin/screens/withdraw_mtrk/withdraw.dart';
import 'package:metrkoin/services/ad_helper.dart';
import 'package:metrkoin/services/api_calls.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../daily_reward/daily_reward.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _mtrkBalance = '0', _referralCode = '', _referralEarning = '',
      _referralSubEarning = '', _totalRefCount = '', _totalSubRefCount = '',
      _username = '', _unixTimeStamp='', _lastRewardTime='';


  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.homePageBannerAdUnit,
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener(),
  );


  @override
  void initState() {
    _fetchUserHomeData();
    _checkForPendingUploads();
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: drawerItems(context, _username, _referralCode, _totalRefCount,
          _referralEarning, _totalSubRefCount, _referralSubEarning,
          _mtrkBalance, _unixTimeStamp, _lastRewardTime),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 10.0),
        color: colorGreyBg,
        child: _body(),
      ),
    );
  }


  Widget _body() {
    double iconSpacing = 12.0;
    double borderRad = 10.0;
    Color color1 = colorPurple;
    Color color2 = colorBlue;

    AdWidget adWidget = AdWidget(ad: myBanner);
    return Column(
      children: [
        accountBalance(),
        Container(
          margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
          height: MediaQuery.of(context).size.height * 0.12,
          child: Center(child: adWidget),
        ),
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(borderRad),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(vertical: iconSpacing, horizontal: iconSpacing),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset("assets/images/icon_game.png", color: colorWhite),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text("Game Arena", style: TextStyle(fontSize: 14.0, color: colorWhite)),
                            ])
                    ),
                    onTap: () {
                      Get.to(
                        GameArena(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(borderRad),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(vertical: iconSpacing, horizontal: iconSpacing),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset("assets/images/icon_reward.png", color: colorWhite),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text("Daily Reward", style: TextStyle(fontSize: 14.0, color: colorWhite),)
                            ])
                    ),
                    onTap: () {
                      Get.to(
                        DailyReward(_unixTimeStamp, _lastRewardTime),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                      );
                    },
                  ),
                )
              ]),
        ),
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(borderRad),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(vertical: iconSpacing, horizontal: iconSpacing),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset("assets/images/icon_wallet.png", color: colorWhite),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text("Account Log", style: TextStyle(fontSize: 14.0, color: colorWhite)),
                            ])
                    ),
                    onTap: () {
                      Get.to(
                        AccountLog(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(borderRad),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(vertical: iconSpacing, horizontal: iconSpacing),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Image.asset("assets/images/icon_withdraw.png", color: colorWhite),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text("Withdraw MTRK", style: TextStyle(fontSize: 14.0, color: colorWhite),),
                            ])
                    ),
                    onTap: () {
                      Get.to(
                        WithdrawMTRK(_mtrkBalance),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                      );
                    },
                  ),
                )
              ]),
        ),
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.circular(borderRad),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(vertical: iconSpacing, horizontal: iconSpacing),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset("assets/images/icon_support.png", color: colorWhite),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text("Support", style: TextStyle(fontSize: 14.0, color: colorWhite)),
                            ])
                    ),
                    onTap: () => launch(_emailLaunchFunction()),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(borderRad),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(vertical: iconSpacing, horizontal: iconSpacing),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Icon(Icons.calculate_outlined, size: 85.0, color: colorWhite),
                              ),
                              SizedBox(height: 5.0),
                              Text("Calculator", style: TextStyle(fontSize: 14.0, color: colorWhite),)
                            ])
                    ),
                    onTap: () {
                      Get.to(
                        Calculator(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                      );
                    },
                  ),
                )
              ]),
        ),
      ],
    );
  }


  Widget accountBalance() {
    double usdEarning = 0.0;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 6.0),
      height: 120.0,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              colors: [colorPurpleLMain, colorPurple]
          ),
      ),
      child: Column(
          children: [
            Text('MTRK Balance', style: TextStyle(fontSize: 13.0, color: colorWhite),),
            Container(
                height: 60.0,
                child: Row(
                    children: [
                      Expanded(child: SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: Image.asset('assets/icons/coin_logo.png'))),
                      Expanded(child: Text(_mtrkBalance!=null ? _mtrkBalance : '0',
                        style: TextStyle(fontSize: 24.0, color: colorWhite),
                        textAlign: TextAlign.center,
                      )),
                      Expanded(child: Container(child: null,))
                    ] )
            ),
            Text('\$' + usdEarning.toStringAsFixed(4) +' USD',
              style: TextStyle(fontSize: 12.0, color: colorWhite),),
          ] ),

    );
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _emailLaunchFunction () {
    Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: SUPPORT_EMAIL_ADDRESS,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Customer Support: MetrKoin'
      }),
    );
    return emailLaunchUri.toString();
  }


  Future _fetchUserHomeData () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    var result = await fetchHomepageData(userId);

    if (result != null) {

      setState(() {
        _mtrkBalance = result['mtrk_balance'].toString();
        _referralCode = result['referral_code'].toString();
        _referralEarning = result['referral_earning'].toString();
        _referralSubEarning = result['referral_sub_level_earning'].toString();
        _totalRefCount = result['total_ref_count'].toString();
        _totalSubRefCount = result['total_sub_ref_count'].toString();
        _username = result['username'].toString();
        _unixTimeStamp = result['last_reward_unix_timestamp'].toString();
        _lastRewardTime = result['last_reward_time'].toString();

      });
    }

  }

  Future _checkForPendingUploads() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    List<String> sudokuData = prefs.getStringList('sudoku_game_saved_data');
    List<String> g2048Data = prefs.getStringList('g2048_game_saved_data');

    if (sudokuData != null) {
      String timestamp = sudokuData[0];
      String amount = sudokuData[1];
      updateUserBalanceForSudoku(userId, timestamp, amount);
    }
    if (g2048Data != null) {
      String timestamp = g2048Data[0];
      String amount = g2048Data[1];
      updateUserBalanceFortyEight(userId, timestamp, amount);
    }
  }



}

