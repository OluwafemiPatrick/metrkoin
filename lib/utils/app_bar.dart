import 'package:flutter/material.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';

PreferredSizeWidget AppBarWidget () {
 return AppBar(
   title: MetrKoinLogo(50.0, 50.0),
   centerTitle: true,
   backgroundColor: colorWhite,
   iconTheme: IconThemeData(color: colorPurple, size: 10),
 );

}