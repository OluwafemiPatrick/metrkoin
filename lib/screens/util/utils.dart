import 'package:flutter/material.dart';
import 'package:metrkoin/screens/util/utils_widget.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';

class UtilsScreen extends StatefulWidget {

  @override
  _UtilsScreenState createState() => _UtilsScreenState();
}

class _UtilsScreenState extends State<UtilsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Container(
          color: colorWhite,
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              UtilsPageWidget(
                title: 'Listed Exchanges',
                icon: Icons.gavel,
                iconColor: colorBlue,
                function: () { }
              ),
              UtilsPageWidget(
                  title: 'MTRK Info',
                  icon: Icons.room_preferences_outlined,
                  iconColor: colorGold,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'Rate Calculator',
                  icon: Icons.calculate_outlined,
                  iconColor: colorRed,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'About MetrKoin',
                  icon: Icons.details_outlined,
                  iconColor: colorBlue,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'F.A.Q',
                  icon: Icons.help_outline,
                  iconColor: colorRed,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'Contact Support',
                  icon: Icons.contact_support_outlined,
                  iconColor: colorBlue,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'Rate on Google Play',
                  icon: Icons.star,
                  iconColor: colorGold,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'Twitter',
                  imageAsset: 'assets/images/icon_twitter.png',
                  iconColor: colorRed,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'Visit Website',
                  icon: Icons.public_outlined,
                  iconColor: colorButtonGrey,
                  function: () { }
              ),
              UtilsPageWidget(
                  title: 'Telegram Channel',
                  imageAsset: 'assets/images/icon_telegram.png',
                  iconColor: colorRed,
                  function: () { }
              ),
            ] ),
        ),
    );
  }
}
