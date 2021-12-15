
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metrkoin/services/ad_helper.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';

class Calculator extends StatefulWidget {

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  double usdEquivalent = 0;
  double mtrkEquivalent = 0;
  double exchangeRate = 0.001;


  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.calculatorPageBannerAdUnit,
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener(),
  );


  @override
  void initState() {
    myBanner.load();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AdWidget adWidget = AdWidget(ad: myBanner);

    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10.0),
          color: colorGreyBg,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        colors: [colorPurpleLMain, colorPurple]
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 50.0,
                          height: 50.0,
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Image.asset('assets/icons/coin_logo.png')),
                      Text ('1 MTRK = \$$exchangeRate USD', style: TextStyle(fontSize: 20.0, color: colorWhite)),
                    ],
                  ),
                ),
                Spacer(flex: 1,),
                _mtrkToUsd(),
                Container(
                  height: 60.0,
                  margin: EdgeInsets.symmetric(vertical: 25.0),
                  child: Center(child: adWidget),
                ),
                _usdToMtrk(),
                Spacer(flex: 3),
              ] ),
        )
    );
  }


  Widget _mtrkToUsd() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('From MTRK to USD', style: TextStyle(fontSize: 15.0, color: colorPurpleLMain)),
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 3.0, left: 15.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter MTRK amount',
                hintStyle: TextStyle(color: colorBlackLight, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 14.0, color: colorBlack),
              onChanged: (value){
                setState(() {
                  usdEquivalent = double.parse(value) * exchangeRate;
                });
              },
            ),
          ),
          Text(' = \$$usdEquivalent USD', style: TextStyle(fontSize: 16.0, color: colorBlack),)

        ],
      ),
    );
  }

  Widget _usdToMtrk() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('From USD to MOK', style: TextStyle(fontSize: 15.0, color: colorPurpleLMain)),
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 3.0, left: 15.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter USD amount',
                hintStyle: TextStyle(color: colorBlackLight, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 14.0, color: colorBlack),
              onChanged: (value){
                setState(() {
                  mtrkEquivalent = double.parse(value) / exchangeRate;
                });
              },
            ),
          ),
          Text(' = $mtrkEquivalent MTRK', style: TextStyle(fontSize: 16.0, color: colorBlack),)

        ],
      ),
    );
  }


  
}
