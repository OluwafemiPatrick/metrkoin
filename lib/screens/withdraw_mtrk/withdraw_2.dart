import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/withdraw_mtrk/withdraw_3.dart';
import 'package:metrkoin/services/api_calls.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:metrkoin/utils/spinner.dart';
import 'package:metrkoin/utils/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawMTRK2 extends StatefulWidget {
  
  final String amount, address;
  WithdrawMTRK2(this.amount, this.address);

  @override
  _WithdrawMTRK2State createState() => _WithdrawMTRK2State();
}

class _WithdrawMTRK2State extends State<WithdrawMTRK2> {

  bool _isLoading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 8.0),
          color: colorGreyBg,
          child: Column(
            children: [
              Divider(color: colorBlue, thickness: 0.5, height: 1.0),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text('Confirm Transaction', style: TextStyle(
                    fontSize: 18.0, color: colorPurple, fontWeight: FontWeight.bold
                ),),
              ),
              Spacer(flex: 1),
              _middleBody(context),
              Spacer(flex: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _isLoading ? Spinner() : DefaultButtonPurple('Confirm', () async {
                  setState(() => _isLoading = true);

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String userId = prefs.getString('user_id');
                  var result = await sendWithdrawalRequest(userId, widget.amount, getTimestamp(), widget.address);

                  if (result == true) {
                    Get.to(
                      WithdrawMTRK3(widget.amount, widget.address),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                    );
                  } else {
                    setState(() {
                      _isLoading = false;
                      _error = 'an error occurred, please check your network connection and try again';
                    });
                  }
                }),
              ),
              SizedBox(height: 5.0),
              Text(_error,
                style: TextStyle(fontSize: 13.0, color: colorRed),
                textAlign: TextAlign.center,
              )
            ]),
        )
    );
  }

  Widget _middleBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.only(left: 6.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 5.0, right: 5.0, left: 12.0),
              child: Text('Amount', style: TextStyle(fontSize: 15.0, color: colorBlack),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, right: 5.0, left: 12.0),
              child: Text('${widget.amount} MTRK',
                style: TextStyle(fontSize: 13.0, color: colorBlack),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Divider(color: colorButtonGrey, thickness: 0.2, height: 0.2,),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 5.0, right: 5.0, left: 12.0),
              child: Text('From', style: TextStyle(fontSize: 15.0, color: colorBlack),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, right: 5.0, left: 12.0),
              child: Text('MetrKoin wallet ($MY_BNB_ADDRESS)',
                style: TextStyle(fontSize: 13.0, color: colorBlack),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Divider(color: colorButtonGrey, thickness: 0.2, height: 0.2,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 5.0, right: 5.0, left: 12.0),
              child: Text('To', style: TextStyle(fontSize: 15.0, color: colorBlack),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, right: 5.0, left: 12.0),
              child: Text(widget.address,
                style: TextStyle(fontSize: 13.0, color: colorBlack),),
            ),
          ] ),
    );
  }
}
