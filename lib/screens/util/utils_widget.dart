import 'package:flutter/material.dart';
import 'package:metrkoin/utils/colors.dart';

Widget UtilsPageWidget({String title, Color iconColor, Function function,
    IconData icon, String imageAsset}) {
  return GestureDetector(
    child: Container(
      height: 45.0,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
                children: [
                  SizedBox(
                      width: 24.0,
                      child: icon!=null ? Icon(icon, size: 22.0, color: iconColor,)
                          : Image.asset(imageAsset, height: 24.0, width: 24.0,)
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(title, style: TextStyle(
                          fontSize: 15.0, color: colorBlack
                      ),),
                    ),
                  ),
                  SizedBox(
                      width: 24.0,
                      child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorBlack,)
                  ),
                ] ),
            Divider(color: colorGrey, height: 0.5,)
          ] ),
    ),
    onTap: () {
      function();
    } ,
  );
}
