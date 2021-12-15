import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/withdraw_mtrk/withdraw_2.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';

class WithdrawMTRK extends StatefulWidget {

  @override
  _WithdrawMTRKState createState() => _WithdrawMTRKState();
}

class _WithdrawMTRKState extends State<WithdrawMTRK> {

  String _withdrawalAddress='', _amountToWithdraw='', _mtrkBalance='0.0000';

  
  @override
  Widget build(BuildContext context) {
    var text = 'Withdrawal requests are processed manually. Please allow up to 24h to receive your MTRK.'
        '\n \nMTRK is built on the Binance BEP-20 protocol, hence we recommend withdrawing to a BEP-20 supported wallet like TrustWallet.'
        '\n \nBlockchain transactions cannot be cancelled or reversed after you submit them. Please make sure that'
        ' your details are correct';
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10.0),
          color: colorWhite,
          child: ListView(
              children: [
                accountBalance(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 15.0, top: 30.0, bottom: 30.0),
                  child: Text(text, style: TextStyle(fontSize: 14.0, color: colorBlack),),
                ),
                withdrawContainers(),
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: DefaultButtonPurple('Withdraw', () {
                    Get.to(
                      WithdrawMTRK2('33500', 'klngif904o43j904gng9034g'),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                    );
                  }),
                ),
                SizedBox(height: 20.0),
              ] ),
        )
    );
  }


  Widget accountBalance() {
    double usdEarning = 0.00;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
      padding: EdgeInsets.only(top: 20.0, bottom: 12.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
        color: colorBlue,
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [colorPurpleLMain, colorPurple]
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Image.asset('assets/icons/coin_logo.png', height: 50.0, width: 50.0,)
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('MOK Token Balance', style: TextStyle(fontSize: 13.0, color: colorWhite),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('$_mtrkBalance MOK',
                              style: TextStyle(fontSize: 18.0, color: colorWhite)),
                        ),
                        Text('\$' + usdEarning.toStringAsFixed(4) + ' USD',
                            style: TextStyle(fontSize: 12.0, color: colorWhite)),

                      ],),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: null,
                  ),
                ] ),
          ]),
    );
  }


  Widget withdrawContainers() {
    return Column(
        children: [
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 15.0),
            padding: EdgeInsets.only(top: 3.0, left: 15.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorButtonGrey),
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter BEP-20 wallet address',
                hintStyle: TextStyle(color: colorBlackLight, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15.0, color: colorBlack),
              onChanged: (value){
                setState(() {
                  _withdrawalAddress = value;
                });
              },
            ),
          ),
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
            padding: EdgeInsets.only(top: 3.0, left: 15.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorButtonGrey),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Amount to withdraw (min: 30,000 MTRK)',
                hintStyle: TextStyle(color: colorBlackLight, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15.0, color: colorBlack),
              onChanged: (value){
                setState(() => _amountToWithdraw = value );
              },
            ),
          ),
        ]);
  }



}
