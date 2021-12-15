import 'package:flutter/material.dart';
import 'package:metrkoin/models/account_log/menu_buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';

class AccountLog extends StatefulWidget {

  @override
  _AccountLogState createState() => _AccountLogState();
}


class _AccountLogState extends State<AccountLog> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MetrKoinLogo(50.0, 50.0),
          centerTitle: true,
          actions:  [
            PopupMenuButton(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(Icons.more_vert, size: 25.0, color: colorPurple,),
              ),
              onSelected: _onMenuItemSelected,
              itemBuilder: (BuildContext context) {
                return accountMenuButtonItems.map((AccountMenuButtons mButton) {
                  return PopupMenuItem<AccountMenuButtons>(
                    value:  mButton,
                    child: Text(mButton.accountMenuButtonItems),
                  );
                }).toList();
            })
          ],
          backgroundColor: colorWhite,
          iconTheme: IconThemeData(color: colorPurple, size: 10),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
          color: colorGreyBg,
          child: ListView(
            children: [
              body("2000", "Sudoku Easy Level Completed", "08:25 Aug 12, 21", "paid"),
              body("2000", "2048 Easy Level Completed", "08:25 Aug 12, 21", ""),
              body("200", "Daily MTRK Earning", "08:25 Aug 12, 21", ""),
              body("2000", "Sub-level Referral Earning", "08:25 Aug 12, 21", ""),
              body("2000", "Sudoku Easy Level Completed", "08:25 Aug 12, 21", "paid"),
              body("2000", "2048 Easy Level Completed", "08:25 Aug 12, 21", "paid"),
              body("200", "Daily MTRK Earning", "08:25 Aug 12, 21", ""),
              body("2000", "Sub-level Referral Earning", "08:25 Aug 12, 21", ""),
              body("2000", "Sudoku Easy Level Completed", "08:25 Aug 12, 21", "paid"),
            ]),
        )
    );
  }


  Widget body(String amount, desc, timestamp, status) {
    Color textColor = colorBlack;
    Color titleColor = colorPurple;
    var textWeight = FontWeight.normal;
    var titleWeight = FontWeight.normal;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: new BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 95.0,
                  child: Text('Description:', style: TextStyle(fontSize: 14.0, color: titleColor, fontWeight: titleWeight),),
                ),
                Expanded(
                    child: Text(desc,
                      style: TextStyle(fontSize: 14.0, color: textColor, fontWeight: textWeight),
                      textAlign: TextAlign.start,
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 95.0,
                  child: Text('Amount:', style: TextStyle(fontSize: 14.0, color: titleColor, fontWeight: titleWeight),),
                ),
                Expanded(
                    child: Text('$amount MTRK',
                      style: TextStyle(fontSize: 14.0, color: textColor, fontWeight: textWeight),
                      textAlign: TextAlign.start,
                    )
                )
              ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 95.0,
                  child: Text('Timestamp:', style: TextStyle(fontSize: 14.0, color: titleColor, fontWeight: titleWeight),),
                ),
                Expanded(
                    child: Text(timestamp,
                      style: TextStyle(fontSize: 14.0, color: textColor, fontWeight: textWeight),
                      textAlign: TextAlign.start,
                    )
                )
              ],
            ),
          ),
          if (status != '')
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 95.0,
                    child: Text('Status:', style: TextStyle(fontSize: 14.0, color: titleColor, fontWeight: titleWeight),),
                  ),
                  Expanded(
                      child: Text(status,
                        style: TextStyle(fontSize: 14.0, color: textColor, fontWeight: textWeight),
                        textAlign: TextAlign.start,
                      )
                  )
                ],
              ),
            ),
        ],
      )
    );
  }


  _onMenuItemSelected(AccountMenuButtons mButton) async {

  }


}
