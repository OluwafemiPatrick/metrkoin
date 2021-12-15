import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/withdraw_mtrk/withdraw_3.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';

class WithdrawMTRK2 extends StatelessWidget {
  
  final String amount, address;
  WithdrawMTRK2(this.amount, this.address);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 20.0),
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
                child: DefaultButtonPurple('Confirm', () {
                  Get.to(
                    WithdrawMTRK3('33500', 'klngif904o43j904gng9034g'),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                  );
                }),
              )
            ],
          ),
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
              child: Text('$amount MOK',
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
              child: Text('MetrKoin - $MY_BNB_ADDRESS',
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
              child: Text(address,
                style: TextStyle(fontSize: 13.0, color: colorBlack),),
            ),
          ] ),
    );
  }

  
}
