import 'package:flutter/material.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';

class FAQ extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String questionOne = 'Is MTRK listed on an exchange?';
    String ansOne = 'The entire MetrKoin team is currently working hard to get MTRK listed on reputable exchanges like PancakeSwap, Coinbase, and eventually Binance';
    String questionTwo = 'I have initiated a withdrawal request, for how long do I have to wait?';
    String ansTwo = 'We process withdrawals manually, and depending on the volume of requests that we receive, you may have to wait for up to 48 hours to receive your payment.'
        '\nYou can see the details of your transaction on the Account Log page';
    String questionThree = 'Is there a withdrawal limit?';
    String ansThree = 'Yes, there is a minimum limit of 30,000 MTRK. MetrKoin covers all transaction charges for withdrawals, therefore it makes sense to process transactions above a certain amount.';
    String questionFour = 'I have a complaint to make or need assistance with some things. How do I go about this?';
    String ansFour = 'Kindly use the Contact Support feature on the previous page. You can also send us an email at support@metrkoin.com. You will receive an automated response with a ticket number, and a representative of ours will respond to you within 24 hours.';
    String questionFive = 'Can I find Monkey Cloud Mining on social media?';
    String ansFive = 'Yes, you can find us on social media by following the links on the previous page.';
    String qSix = 'What is the current value of MTRK?';
    String aSix = 'The value of MTRK is determined by the community of gamers who make use of the platform and exchange the coin. For the Initial Coin offering phase however, the value is pegged at 0.001 USD';
    String qSeven = '';

    Color textColor = colorBlack;
    Color titleColor = colorPurpleLMain;

    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorGreyBg,
          child: ListView(
              padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
              children: [
                SizedBox(height: 20.0,),
                Text(questionOne, style: TextStyle(fontSize: 16.0, color: titleColor),),
                SizedBox(height: 15.0,),
                Text(ansOne, style: TextStyle(fontSize: 14.0, color: textColor),),
                SizedBox(height: 40.0,),
                Text(qSix, style: TextStyle(fontSize: 16.0, color: titleColor),),
                SizedBox(height: 15.0,),
                Text(aSix, style: TextStyle(fontSize: 14.0, color: textColor),),
                SizedBox(height: 40.0,),
                Text(questionTwo, style: TextStyle(fontSize: 16.0, color: titleColor),),
                SizedBox(height: 15.0,),
                Text(ansTwo, style: TextStyle(fontSize: 14.0, color: textColor),),
                SizedBox(height: 40.0,),
                Text(questionThree, style: TextStyle(fontSize: 16.0, color: titleColor),),
                SizedBox(height: 15.0,),
                Text(ansThree, style: TextStyle(fontSize: 14.0, color: textColor),),
                SizedBox(height: 40.0,),
                Text(questionFour, style: TextStyle(fontSize: 16.0, color: titleColor),),
                SizedBox(height: 15.0,),
                Text(ansFour, style: TextStyle(fontSize: 14.0, color: textColor),),
                SizedBox(height: 40.0,),
                Text(questionFive, style: TextStyle(fontSize: 16.0, color: titleColor),),
                SizedBox(height: 15.0,),
                Text(ansFive, style: TextStyle(fontSize: 14.0, color: textColor),),
                SizedBox(height: 50.0,),
              ] ),
        )
    );

  }
}
