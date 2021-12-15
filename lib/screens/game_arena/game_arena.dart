import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/game_arena/2048/game_widget.dart';
import 'package:metrkoin/screens/game_arena/sudoku/sudoku.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';

class GameArena extends StatefulWidget {

  @override
  _GameArenaState createState() => _GameArenaState();
}

class _GameArenaState extends State<GameArena> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0, top: 15.0),
          color: colorGreyBg,
          child: _body(),
        )
    );
  }

  Widget _body() {
    return Column(
      children: [
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width*0.9,
          child: ElevatedButton(
            child: Center(child: Text('Sudoku', style: TextStyle(
                color: colorWhite, fontSize: 17.0))
            ),
            onPressed: () async {
              Get.to(
                Sudoku(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
              );
            },
          ),
        ),
        SizedBox(height: 100.0),
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width*0.9,
          child: ElevatedButton(
            child: Center(child: Text('2048', style: TextStyle(
                color: colorWhite, fontSize: 17.0))
            ),
            onPressed: () async {
              Get.to(
                GameWidget(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
              );
            },
          ),
        )

      ] );
  }
}
