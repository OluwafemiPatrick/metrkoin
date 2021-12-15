import 'package:flutter/material.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';

class AboutMetrKoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          color: colorWhite,
          child: Column(
            children: [
              Spacer(flex: 1,),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Image.asset('assets/icons/metrkoin.png')
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                padding: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                child: Image.asset('assets/images/metrkoin120.png'),
              ),
              Text('Version: $VERSION_NUMBER', style: TextStyle(fontSize: 14.0, color: colorBlack),),
              SizedBox(height: 10.0,),
              Text('Copyright @ MetrKoin 2021', style: TextStyle(fontSize: 14.0, color: colorBlack),),
              SizedBox(height: 10.0,),
              Text('All rights reserved.', style: TextStyle(fontSize: 14.0, color: colorBlack),),

              Spacer(flex: 2,),


            ],
          ),
        )
    );
  }
}
