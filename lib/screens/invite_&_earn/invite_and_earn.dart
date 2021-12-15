import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metrkoin/services/ad_helper.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/toast.dart';
import 'package:share_plus/share_plus.dart';

class InviteAndEarn extends StatefulWidget {

  final String referralCode;
  InviteAndEarn(this.referralCode);

  @override
  _InviteAndEarnState createState() => _InviteAndEarnState();
}

class _InviteAndEarnState extends State<InviteAndEarn> {

  String _referralCode='', _referralCount='0', _referralEarnings='0.0000',
      _subLevelRefCount='0', _subLevelRefEarning='0.0000';

  @override
  void initState() {
    _getReferralCode();
    myBanner.load();
    super.initState();
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.invitePageBannerAdUnit,
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener(),
  );

  @override
  Widget build(BuildContext context) {
    AdWidget adWidget = AdWidget(ad: myBanner);
    String _mssg = 'You earn 200 MTRK as a bonus every time a new user uses your invitation code to join, and the new user earns 50 MTRK.\n'
        '\nYou also earn 20 MTRK for every user that your referrals invite (sub-level referrals) up to the 5th sub-level.';

    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0, top: 15.0),
          color: colorGreyBg,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('Invite people and earn extra MTRK',
                  style: TextStyle(color: colorPurpleLMain, fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: Text(_mssg, style: TextStyle(color: colorBlack, fontSize: 14.0),),
              ),
              SizedBox(height: 40.0),
              referralInfo(),
              Container(
                height: 80.0,
                child: Center(child: adWidget),
              ),
              subLevelReferralInfo(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 8.0, right: 8.0, top: 60.0),
                child: Text('Your Invitation Code', style: TextStyle(color: colorPurpleLMain, fontSize: 15.0)),
              ),
              bottomButtons(),
              SizedBox(height: 20.0,)
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
                    child: Text('$_referralCount', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
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
                    child: Text('$_referralEarnings', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
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
                    child: Text('$_subLevelRefCount', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
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
                    child: Text('$_subLevelRefEarning', style: TextStyle(fontSize: 14.0, color: colorBlack), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
          ] ),
    );
  }


  Widget bottomButtons() {
    return Row(
      children: [
        SizedBox(width: 8.0,),
        Expanded(
          child: Container(
            height: 46.0,
            child: ElevatedButton(
              child: Row(
                children: [
                  SizedBox(width: 8.0),
                  Text(_referralCode!=null ? _referralCode : '',
                    style: TextStyle(color: colorWhite, fontSize: 13.0, fontWeight: FontWeight.normal),),
                  Spacer(flex: 1),
                  SizedBox(
                      width: 35.0,
                      child: Icon(Icons.copy, size: 25.0, color: colorWhite))
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: colorBgLighter,
                onSurface: colorGrey,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 2,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _referralCode));
                toastMessage("code copied to clipboard");
              },
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            height: 50.0,
            child: DefaultButtonPurple('Invite', () {
              Share.share("Hii, kindly sign up on MetrKoin using my referral code $_referralCode");
            })
          ),
        ),
        SizedBox(width: 8.0,),
      ],
    );
  }



  Future _getReferralCode() async {
    setState(() {
      _referralCode = widget.referralCode;
    });
  }



}
