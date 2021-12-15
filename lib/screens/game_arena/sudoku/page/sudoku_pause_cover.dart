import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metrkoin/screens/game_arena/sudoku/state/sudoku_state.dart';
import 'package:scoped_model/scoped_model.dart';

class SudokuPauseCoverPage extends StatefulWidget {
  SudokuPauseCoverPage({Key key}) : super(key: key);

  @override
  _SudokuPauseCoverPageState createState() => _SudokuPauseCoverPageState();
}

class _SudokuPauseCoverPageState extends State<SudokuPauseCoverPage> {
  SudokuState get _state => ScopedModel.of<SudokuState>(context);

  @override
  Widget build(BuildContext context) {
    TextStyle pageTextStyle = TextStyle(color: Colors.white);

    Widget titleView = Align(child: Text("Game paused", style: TextStyle(fontSize: 22)));

    Widget bodyView = Align(
        child: Column(children: [
      Expanded(flex: 3, child: titleView),
      Expanded(flex: 5, child: Text("Elapsed time ${_state.timer}")),
      Expanded(
        flex: 1,
        child: Align(alignment: Alignment.center, child: Text("Double-tap the screen to continue the game")),
      )
    ]));

    var onDoubleTap = () {
      print("Double click to exit the current pause");
      Navigator.pop(context);
    };
    var onTap = () {
      print("You click to have a bird use，Double click");
    };
    return GestureDetector(
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.95),
            body: DefaultTextStyle(child: bodyView, style: pageTextStyle)),
        onTap: onTap,
        onDoubleTap: onDoubleTap
    );
  }
}
