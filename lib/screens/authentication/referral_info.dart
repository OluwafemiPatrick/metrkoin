import 'package:flutter/material.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';

class ReferralInfo extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    String mssg = 'Sign up to MetrKoin using a referral code to earn 50 MTRK. After signing up, you will be '
        'assigned a referral code which you can use to invite new users and earn 200 MTRK for every new user that uses your code.\n'
        ' \nYou also earn 20 MTRK for every user that your referrals invite (sub-level referrals) up to the 5th sub-level.';

    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0, top: 15.0),
          color: colorGreyBg,
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text('Invite people and earn extra MTRK',
                    style: TextStyle(color: colorPurpleLMain, fontSize: 15.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                  child: Text(mssg, style: TextStyle(color: colorBlack, fontSize: 14.0),),
                ),
                Spacer(flex: 1,),
                referralInfo(),
                Spacer(flex: 1,),
                subLevelReferralInfo(),
                Spacer(flex: 4,)
              ] ),
        )
    );

  }


  Widget referralInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Text('Referral Earnings', style: TextStyle(color: colorPurpleLMain, fontSize: 15.0)),
            ),
            Divider(color: colorButtonGrey, thickness: 0.5, height: 20.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(children: [
                SizedBox(width: 6.0,),
                Expanded(
                    child: Text('Total referrals', style: TextStyle(fontSize: 14.0, color: colorBlack),)
                ),
                SizedBox(
                    width: 60.0,
                    child: Text('0', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(children: [
                SizedBox(width: 6.0,),
                Expanded(
                    child: Text('Total MTRK earned from referrals', style: TextStyle(fontSize: 14.0, color: colorBlack),)
                ),
                SizedBox(
                    width: 80.0,
                    child: Text('0.0000', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
          ] ),
    );
  }

  Widget subLevelReferralInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Text('Sub-level Referral Earnings', style: TextStyle(color: colorPurpleLMain, fontSize: 15.0)),
            ),
            Divider(color: colorButtonGrey, thickness: 0.5, height: 20.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(children: [
                SizedBox(width: 6.0,),
                Expanded(
                    child: Text('Total sub-level referrals', style: TextStyle(fontSize: 14.0, color: colorBlack),)
                ),
                SizedBox(
                    width: 60.0,
                    child: Text('0', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(children: [
                SizedBox(width: 6.0,),
                Expanded(
                    child: Text('Earnings from sub-level referrals', style: TextStyle(fontSize: 14.0, color: colorBlack),)
                ),
                SizedBox(
                    width: 80.0,
                    child: Text('0.0000', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
          ] ),
    );
  }



}
