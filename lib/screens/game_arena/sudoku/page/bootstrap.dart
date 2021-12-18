import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:metrkoin/screens/game_arena/sudoku/state/sudoku_state.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sudoku_dart/sudoku_dart.dart';


class BootstrapPage extends StatefulWidget {
  BootstrapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BootstrapPageState createState() => _BootstrapPageState();
}

Widget _buttonWrapper(BuildContext context, Widget childBuilder(BuildContext content)) {
  return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: 300,
      height: 60,
      child: childBuilder(context));
}


Widget _continueGameButton(BuildContext context) {
  return ScopedModelDescendant<SudokuState>(builder: (context, child, state) {
    return Offstage(
        offstage: state.status != SudokuGameStatus.pause,
        child: Container(
          width: 300,
          height: 80,
          child: CupertinoButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Text("Continue the game", style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold))),
                  Container(
                      child: Text(
                          '${LEVEL_NAMES[state.level]} - ${state.timer}',
                          style: TextStyle(fontSize: 13)))
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/gaming");
              }),
        ));
  });
}

void _internalSudokuGenerate(List<dynamic> args) {
  LEVEL level = args[0];
  SendPort sendPort = args[1];

  Sudoku sudoku = Sudoku.generator(level);
  List<int> puzzle = sudoku.puzzle;
  print(puzzle);
  sendPort.send(sudoku);
}

Future sudokuGenerate(BuildContext context, LEVEL level) async {

  ReceivePort receivePort = ReceivePort();

  Isolate isolate = await Isolate.spawn(_internalSudokuGenerate, [level, receivePort.sendPort]);
  var data = await receivePort.first;
  Sudoku sudoku = data;
  SudokuState state = ScopedModel.of<SudokuState>(context);
  state.initialize(sudoku: sudoku, level: level);
  state.updateStatus(SudokuGameStatus.pause);
  receivePort.close();
  isolate.kill(priority: Isolate.immediate);

}



Widget _newGameButton(BuildContext context) {
  return _buttonWrapper(context,
      (_) => DefaultButtonPurple('New Game', () {
        Widget cancelView = SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: CupertinoButton(
                  child: Text("Dismiss", style: TextStyle(color: colorRed),),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ))
        );

        List<Widget> buttons = [];
        LEVEL_NAMES.forEach((level, name) {
          var levelName = name;

          Widget button = SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(2.0),
                  child: CupertinoButton(
                    child: Text(levelName, style: TextStyle(fontWeight: FontWeight.w600),),
                    onPressed: () async {
                      await sudokuGenerate(context, level);
                      Navigator.popAndPushNamed(context, "/gaming");

                      return Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Center(
                              child: Text('Loading ...', style: TextStyle(color: Colors.black)))
                      );
                    },
                  ))
          );
          buttons.add(button);
        });

        buttons.add(cancelView);

        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                    child: Container(
                        height: 320,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: buttons))
                ),
              ),
            );
          },
        );
      })
  );
}


class _BootstrapPageState extends State<BootstrapPage> {

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
        color: colorWhite,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 1,),
          Container(
              alignment: Alignment.centerLeft,
              child: Image(
                image: AssetImage("assets/images/sudoku_logo.png"),
              )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Challenge',
                style: TextStyle(fontSize: 32.0, color: colorGrey, fontStyle: FontStyle.italic),),
            ),
          ),
          _middleBody(),
          Spacer(flex: 3,),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _continueGameButton(context),
                _newGameButton(context),
          ])
        ])
    );

    return ScopedModelDescendant<SudokuState>(
        builder: (context, child, model) => Scaffold(
            appBar: AppBarWidget(),
            body: body
        )
    );
  }


  Widget _middleBody() {
    var titleWeight = FontWeight.w600;
    Color colorLeft = colorBlue;
    Color colorTop = colorPurple;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyBg, width: 5),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: [
          Container(
            height: 50.0,
            color: colorGreyBg,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('')
                ),
                Expanded(
                  flex: 2,
                  child: Text('EASY',
                    style: TextStyle(color: colorTop, fontSize: 14.0, fontWeight: titleWeight),
                    textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('MEDIUM',
                      style: TextStyle(color: colorTop, fontSize: 14.0, fontWeight: titleWeight),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('HARD',
                      style: TextStyle(color: colorTop, fontSize: 14.0, fontWeight: titleWeight),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('EXPERT',
                      style: TextStyle(color: colorTop, fontSize: 14.0, fontWeight: titleWeight),
                      textAlign: TextAlign.center,
                    )
                ),
              ]),
          ),
          Container(
            height: 50.0,
            color: colorWhite,
            padding: EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('MTRK reward',
                      style: TextStyle(color: colorLeft, fontSize: 14.0, fontWeight: titleWeight),
                      textAlign: TextAlign.left,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('1000',
                      style: TextStyle( fontSize: 14.0,),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('1500',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('2000',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('2500',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),

              ],
            ),
          ),
          Container(
            height: 50.0,
            color: colorGreyBg,
            padding: EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Time to play',
                      style: TextStyle(color: colorLeft, fontSize: 14.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('20',
                      style: TextStyle( fontSize: 14.0,),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('16',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('12',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('8',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
              ]),
          ),
          Container(
            height: 50.0,
            color: colorWhite,
            padding: EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Available life',
                      style: TextStyle(color: colorLeft, fontSize: 14.0, fontWeight: titleWeight),
                      textAlign: TextAlign.left,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('20',
                      style: TextStyle( fontSize: 14.0,),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('15',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('10',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('5',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
              ]),
          ),
          Container(
            height: 50.0,
            color: colorGreyBg,
            padding: EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Available hint',
                      style: TextStyle(color: colorLeft, fontSize: 14.0, fontWeight: titleWeight),
                      textAlign: TextAlign.left,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('5',
                      style: TextStyle( fontSize: 14.0,),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('4',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('3',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Text('2',
                      style: TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    )
                ),
              ] ),
          ),
        ] ),
    );
  }


}
