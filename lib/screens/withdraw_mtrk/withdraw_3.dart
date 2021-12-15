import 'package:flutter/material.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/return_to_home.dart';

class WithdrawMTRK3 extends StatelessWidget {

  final String amount, address;
  WithdrawMTRK3(this.amount, this.address);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(backgroundColor: colorWhite),
          preferredSize: Size.fromHeight(0),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0),
          color: colorGreyBg,
          child: Column(
              children: [
                Spacer(flex: 1),
                Container(
                  width: 120.0,
                  height: 120.0,
                  child: Image.asset('assets/images/confirm.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 14.0),
                  child: Text('Your withdrawal request has been received.',
                    style: TextStyle(fontSize: 16.0, color: colorBlack),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Your wallet $address will be credited with $amount MTRK within 48 hours.',
                    style: TextStyle(fontSize: 13.0, color: colorBlack),
                    textAlign: TextAlign.center,),
                ),
                Spacer(flex: 2,),
                DefaultButtonPurple('Return to HomePage', () {
                  returnToHomePage(context);
                })
              ] ),
        )
    );
  }


}
