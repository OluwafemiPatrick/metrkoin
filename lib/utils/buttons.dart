import 'package:flutter/material.dart';
import 'package:metrkoin/utils/colors.dart';

class DefaultButtonPurple extends StatelessWidget {

  final String buttonText;
  final Function onPressed;

  DefaultButtonPurple(this.buttonText, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 46.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [colorPurpleLMain, colorBlue]
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
          ),
          minimumSize: MaterialStateProperty.all(Size(
              MediaQuery.of(context).size.width*0.9, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10,),
          child: Text(buttonText,
            style: TextStyle(fontSize: 15, color: Colors.white,),
          ),
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}
