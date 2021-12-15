import 'package:flutter/material.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';

class DailyReward extends StatefulWidget {

  @override
  _DailyRewardState createState() => _DailyRewardState();
}

class _DailyRewardState extends State<DailyReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0, top: 15.0),
          color: colorGreyBg,
          child: body(),
        )
    );
  }


  Widget body() {
    return Container();
  }

}
