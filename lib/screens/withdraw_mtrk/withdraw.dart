import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/withdraw_mtrk/withdraw_2.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';

class WithdrawMTRK extends StatefulWidget {

  final String mtrkBalance;
  WithdrawMTRK(this.mtrkBalance);

  @override
  _WithdrawMTRKState createState() => _WithdrawMTRKState();
}

class _WithdrawMTRKState extends State<WithdrawMTRK> {

  String _withdrawalAddress='', _amountToWithdraw='', _mtrkBalance='0';
  bool _isError = false;
  String errorMsg = '';

  @override
  void initState() {
    setState(() {
      _mtrkBalance = widget.mtrkBalance;
    });
    super.initState();
  }
  
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

                    if (_withdrawalAddress.isNotEmpty && _amountToWithdraw.isNotEmpty) {
                      double amount = double.parse(_amountToWithdraw);
                      double balance = double.parse(_mtrkBalance);

                      if (amount >= 30000) {
                        if (balance >= amount) {
                          Get.to(
                            WithdrawMTRK2(_amountToWithdraw, _withdrawalAddress),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
                          );
                        }
                        else setState(() => errorMsg = 'you do not have sufficient balance');
                      }
                      else setState(() => errorMsg = 'withdrawal amount cannot be less than 30,000 MTRK');
                    }
                    else setState(() => _isError = true);

                  }),
                ),
                SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(errorMsg, style: TextStyle(fontSize: 13.0, color: colorRed),)),
                SizedBox(height: 15.0),
              ] ),
        )
    );
  }


  Widget accountBalance() {
    double usdEarning = 0.0;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 6.0),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
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


  Widget withdrawContainers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0,),
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
                  _isError = false;
                });
              },
            ),
          ),
          if (_isError)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('all fields are required', style: TextStyle(fontSize: 12.0, color: colorRed),),
            ),
          SizedBox(height: 15.0,),
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 15.0, right: 15.0,),
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
                setState(() {
                  _amountToWithdraw = value;
                  _isError = false;
                });
              },
            ),
          ),
          if (_isError)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('all fields are required', style: TextStyle(fontSize: 12.0, color: colorRed),),
            ),
          SizedBox(height: 30.0,)
        ]);
  }




}
