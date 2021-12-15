import 'package:flutter/material.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';

class DailyRewards extends StatefulWidget {

  @override
  _DailyRewardsState createState() => _DailyRewardsState();
}

class _DailyRewardsState extends State<DailyRewards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0, top: 15.0),
          color: colorGreyBg,
        )
    );
  }
}
