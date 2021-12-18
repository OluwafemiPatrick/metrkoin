import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/account_log/account_log.dart';
import 'package:metrkoin/screens/daily_reward/daily_reward.dart';
import 'package:metrkoin/screens/game_arena/game_arena.dart';
import 'package:metrkoin/screens/homepage/faq.dart';
import 'package:metrkoin/screens/invite_&_earn/invite_and_earn.dart';
import 'package:metrkoin/screens/homepage/about.dart';
import 'package:metrkoin/screens/withdraw_mtrk/withdraw.dart';
import 'package:metrkoin/services/auth.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Widget drawerItems(BuildContext context) {

  double verticalMargin = 10.0;
  double iconPaddling = 6.0;
  double iconToTextPad = 26.0;
  double _drawerTextSize = 17.0;
  double _iconSize = 8.0;

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _emailLaunchFunction () {
    Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: SUPPORT_EMAIL_ADDRESS,
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Customer Support: MetrKoin'
      }),
    );
    return emailLaunchUri.toString();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  return Drawer(
      child: ListView(
          padding: const EdgeInsets.only(left: 10.0, right: 5.0, bottom: 20.0),
          children: <Widget>[
            SizedBox(height: 75,),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        child: Image.asset('assets/images/profile_image.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text('MetrKoin User', style: TextStyle(fontSize: 13.0, color: colorBlack),),
                      )
                    ],
                  ),
                  Spacer(flex: 1)
                ],
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Game Arena', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    GameArena(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Invite & Earn', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    InviteAndEarn('u4gfuiefbf'),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Withdraw MTRK', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    WithdrawMTRK(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Daily Reward', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    DailyReward(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Account Log', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    AccountLog(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Update Profile', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('MTRK Info', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () { },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Contact Support', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () => launch(_emailLaunchFunction()),
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('F.A.Q', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    FAQ(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Divider(thickness: 0.5, color: colorBlueIcon,),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('About MetrKoin', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  Get.to(
                    AboutMetrKoin(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Rate App', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () { },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorBlue,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Visit Website', style: TextStyle(fontSize: _drawerTextSize),),
                      )
                    ]),
                onTap: () {
                  _launchURL(WEBSITE_URL);
                },
              ),
            ),
            Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              padding: EdgeInsets.only(left: iconPaddling),
              child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: colorRed,
                        size: _iconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: iconToTextPad),
                        child: Text('Log out', style: TextStyle(fontSize: _drawerTextSize, color: colorRed),),
                      )
                    ]),
                onTap: () async {
                  AuthServices auth = new AuthServices();

                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text("Sure to logout?"),
                            content: Text("You are about to log out of MetrKoin",
                                style: TextStyle(fontSize: 14.0)),
                            actions: [
                              TextButton(
                                child: Text("dismiss"),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              TextButton(
                                child: Text("logout"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            ]);
                      }).then((val) async {
                    bool confirm = val;
                    if (confirm == true) {
                      await auth.signOut();
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ),

          ]
      )
  );


}