import 'package:flutter/material.dart';
import 'package:metrkoin/services/api_calls.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/spinner.dart';
import 'package:metrkoin/utils/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyReward extends StatefulWidget {

  final String unixTimestamp;
  final String timestamp;

  DailyReward(this.unixTimestamp, this.timestamp);

  @override
  _DailyRewardState createState() => _DailyRewardState();
}

class _DailyRewardState extends State<DailyReward> {

  bool _isEligible = false;
  bool _isLoading = false;
  String _unixTimestamp = '';
  String _timestamp = '';
  String _newTimeToClaim = '';

  @override
  void initState() {
    setState(() {
      _unixTimestamp = widget.unixTimestamp;
      _timestamp = widget.timestamp;
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    _calculateTime();
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0, right: 10.0),
          color: colorWhite,
          child: body(),
        )
    );
  }


  Widget body() {
    String _rewardText = 'Your last daily reward was claimed on $_timestamp';
    String text1 = "You are eligible for today's MTRK reward";
    String text2 = 'You are not eligible for a reward yet. \nCome back in $_newTimeToClaim to claim reward';
    String error = '';
    return Column(
      children: [
        Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(_rewardText, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, color: colorBlack),),
        ),
        Container(
            height: 100.0,
            width: 100.0,
            child: Image.asset('assets/icons/coin_logo.png',)
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(_isEligible? text1 : text2, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, color: colorBlue),),
        ),
        Spacer(flex: 2),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          child: _isLoading ? Spinner() : DefaultButtonPurple('Claim Reward', () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? userId = prefs.getString('user_id');

            if (_isEligible) {
              setState(() => _isLoading = true);
              await sendDailyReward(userId!, getTimestamp(), getUnixTimestamp()).then((value) {
                // navigate to home page
                setState(() => _isLoading = false);
              });
            }
            else if (!_isEligible) setState(() => error = 'you are not eligible yet');

          }),
        ),
        SizedBox(height: 5.0,),
        Text(error, style: TextStyle(fontSize: 13.0, color: colorRed),)
      ],
    );
  }


  String getUnixTimestamp() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;

    String currentUnixTime = (ms / 1000).round().toString();
    return currentUnixTime;
  }


  _calculateTime() {

    if (_unixTimestamp.isEmpty) {
      setState(() {
        _isEligible = true;
        _timestamp = "null";
      });
    }
    else {
      var ms = (new DateTime.now()).microsecondsSinceEpoch;

      int unixTime = int.parse(_unixTimestamp);
      int currentUnixTime = (ms / 1000).round();
      var eligibleUnixTime = (unixTime/1000) + 86400;
      var timeDiffInSec = (currentUnixTime - unixTime) / 1000;
      var timeBeforeNextRewardInSec = eligibleUnixTime - (currentUnixTime/1000);

      if (timeDiffInSec >= 86400) {
        setState(() => _isEligible = true);
      }

      // calculate time left before next reward
      int hourLeft, minutesLeft;
      hourLeft = (timeBeforeNextRewardInSec ~/ 3600);

      if (hourLeft > 0) {
        var hourInSeconds = hourLeft * 3600;
        minutesLeft = ((timeBeforeNextRewardInSec-hourInSeconds) ~/ 60);
        setState(() {
          _newTimeToClaim = hourLeft.toString() + 'hr ' + minutesLeft.toString() + 'min';
        });
      }
      else {
        minutesLeft = timeBeforeNextRewardInSec ~/ 60;
        setState(() {
          _newTimeToClaim = hourLeft.toString() + 'hr ' + minutesLeft.toString() + 'min';
        });
      }
    }

  }

}
