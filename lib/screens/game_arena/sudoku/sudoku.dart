import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrkoin/screens/game_arena/sudoku/page/bootstrap.dart';
import 'package:metrkoin/screens/game_arena/sudoku/page/sudoku_game.dart';
import 'package:metrkoin/screens/game_arena/sudoku/state/sudoku_state.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:scoped_model/scoped_model.dart';

class Sudoku extends StatefulWidget {

  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {

  BootstrapPage bootstrapPage = BootstrapPage();

  Future<SudokuState> _loadState() async {
    SudokuState sudokuState = await SudokuState.resumeFromDB();
    return sudokuState;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadState(),
      builder: (context, AsyncSnapshot<SudokuState> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Center(
                  child: Text('Sudoku loading ...', style: TextStyle(color: colorPurpleMain, fontSize: 16.0))
              )
          );
        }

        SudokuState sudokuState = snapshot.data;
        BootstrapPage bootstrapPage = BootstrapPage();
        SudokuGamePage sudokuGamePage = SudokuGamePage();


        return ScopedModel(
          model: sudokuState,
          child: MaterialApp(
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: colorWhite,
              accentColor: colorWhite,
            ),
            home: bootstrapPage,
            routes: <String, WidgetBuilder>{
              "/bootstrap": (context) => bootstrapPage,
              "/newGame": (context) => SudokuGamePage(),
              "/gaming": (context) => sudokuGamePage
            },
          ),
        );

      },
    );
  }

}
