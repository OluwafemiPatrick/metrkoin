import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:metrkoin/utils/colors.dart';


class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitCircle(
          color: colorPurpleLMain,
          size: 60.0,
        ),
      ),
    );
  }
}


class SpinnerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitCircle(
          color: colorWhite,
          size: 60.0,
        ),
      ),
    );
  }
}
