import 'package:fluttertoast/fluttertoast.dart';
import 'package:metrkoin/utils/colors.dart';


toastMessage(String toastmessage){

  Fluttertoast.showToast(
      msg: toastmessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: colorWhite,
      textColor: colorBlack,
      fontSize: 16.0
  );
}

