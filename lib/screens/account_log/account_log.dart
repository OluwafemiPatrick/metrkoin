import 'package:flutter/material.dart';
import 'package:metrkoin/models/account_log/account_log_model.dart';
import 'package:metrkoin/models/account_log/menu_buttons.dart';
import 'package:metrkoin/services/api_calls.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';
import 'package:metrkoin/utils/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountLog extends StatefulWidget {

  @override
  _AccountLogState createState() => _AccountLogState();
}


class _AccountLogState extends State<AccountLog> {

  List<AccountLogModel> accountLogDataAll = [];
  List<AccountLogModel> accountLogDataGames = [];
  List<AccountLogModel> accountLogDataRewards = [];
  List<AccountLogModel> accountLogDataWithdrawal = [];

  bool _isLoading = true;
  String status = 'all';

  @override
  void initState() {
    _fetchLogData();
    super.initState();
  }

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
          child: _isLoading? Spinner() : Container(
            child: bodySwitcher(),
          )
        )
    );
  }



  Widget bodySwitcher() {

    if (status == 'games') {
      return ListView.builder(
        itemCount: accountLogDataGames.length,
        itemBuilder: (context, index) {
          return body(
              accountLogDataGames[index].amount,
              accountLogDataGames[index].description,
              accountLogDataGames[index].timestamp,
              accountLogDataGames[index].status,
              accountLogDataGames[index].type,
              accountLogDataGames[index].docId
          );
        },
      );
    }
    if (status == 'rewards') {
      return ListView.builder(
        itemCount: accountLogDataRewards.length,
        itemBuilder: (context, index) {
          return body(
              accountLogDataRewards[index].amount,
              accountLogDataRewards[index].description,
              accountLogDataRewards[index].timestamp,
              accountLogDataRewards[index].status,
              accountLogDataRewards[index].type,
              accountLogDataRewards[index].docId
          );
        },
      );
    }
    if (status == 'withdrawals') {
      return ListView.builder(
        itemCount: accountLogDataWithdrawal.length,
        itemBuilder: (context, index) {
          return body(
              accountLogDataWithdrawal[index].amount,
              accountLogDataWithdrawal[index].description,
              accountLogDataWithdrawal[index].timestamp,
              accountLogDataWithdrawal[index].status,
              accountLogDataWithdrawal[index].type,
              accountLogDataWithdrawal[index].docId
          );
        },
      );
    }
    else {
      return ListView.builder(
        itemCount: accountLogDataAll.length,
        itemBuilder: (context, index) {
          return body(
              accountLogDataAll[index].amount,
              accountLogDataAll[index].description,
              accountLogDataAll[index].timestamp,
              accountLogDataAll[index].status,
              accountLogDataAll[index].type,
              accountLogDataAll[index].docId
          );
        },
      );
    }
  }


  Widget body(int amount, String desc, timestamp, status, type, docId) {
    Color textColor = colorBlack;
    Color titleColor = colorPurple;
    var textWeight = FontWeight.normal;
    var titleWeight = FontWeight.normal;
    String description = '';

    if (type == 'withdrawal') {
      description = 'Withdrawal to $desc';
    } else{
      description = desc;
    }
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
                    child: Text(description,
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
                        style: TextStyle(fontSize: 14.0, color: status=='processing' ? colorRed : colorGreen,
                            fontWeight: textWeight), textAlign: TextAlign.start,
                      )
                  )
                ],
              ),
            ),
        ])
    );
  }


  _onMenuItemSelected(AccountMenuButtons mButton) async {
    if (mButton.accountMenuButtonItems == 'All'){
      setState(() => status = 'all');
    }
    if (mButton.accountMenuButtonItems == 'Completed games'){
      setState(() => status = 'games');
    }
    if (mButton.accountMenuButtonItems == 'Daily rewards'){
      setState(() => status = 'rewards');
    }
    if (mButton.accountMenuButtonItems == 'Withdrawals'){
      setState(() => status = 'withdrawals');
    }
  }


  Future _fetchLogData () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    var result = await fetchLogData(userId);

    if (result != null) {
      setState(() {
        accountLogDataAll = result.reversed.toList();
        _isLoading = false;

        for (var data in result.reversed.toList()) {
          if (data.type == 'withdrawal') {
            accountLogDataWithdrawal.add(data);
          }
        }
        for (var data in result.reversed.toList()) {
          if (data.type == 'game') {
            accountLogDataGames.add(data);
          }
        }
        for (var data in result.reversed.toList()) {
          if (data.type == 'daily_reward') {
            accountLogDataRewards.add(data);
          }
        }
      });
    }

  }


}
