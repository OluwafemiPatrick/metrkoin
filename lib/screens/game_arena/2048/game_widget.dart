import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metrkoin/models/game_arena/G2048_drop_down.dart';
import 'package:metrkoin/screens/game_arena/2048/cell_box.dart';
import 'package:metrkoin/screens/game_arena/2048/game.dart';
import 'package:metrkoin/screens/game_arena/2048/scoreboard.dart';
import 'package:metrkoin/services/ad_helper.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';
import 'package:metrkoin/utils/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'g2048_getter_and_setter.dart';

class GameWidget extends StatefulWidget {

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {

  Game _game;
  MediaQueryData _queryData;
  final int row=4;
  final int column=4;
  final double cellPadding=5.0;
  final EdgeInsets _gameMargin = EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0);
  bool _isDragging=false;
  bool _isGameOver=false;


  @override
  void initState(){
    super.initState();
    myBanner.load();
    _game = Game(row,column);
    newGame();
  }

  void newGame(){
    _game.init();
    _isGameOver=false;
    setState(() { });
  }

  void _newGame2(){
    _game.init2(_game.score, _game.earning);
    _isGameOver=false;
    setState(() { });
  }

  void moveLeft(){
    setState(() {
      _game.moveLeft();
      checkGameOver();
    });
  }

  void moveRight() {
    setState(() {
      _game.moveRight();
      checkGameOver();
    });
  }

  void moveUp() {
    setState(() {
      _game.moveUp();
      checkGameOver();
    });
  }

  void moveDown() {
    setState(() {
      _game.moveDown();
      checkGameOver();
    });
  }

  void checkGameOver() {
    if (_game.isGameOver()) {
      _isGameOver = true;
    }
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.G2048BannerAdUnit,
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener(),
  );


  @override
  Widget build(BuildContext context) {
    AdWidget adWidget = AdWidget(ad: myBanner);

    List<CellWidget> _cellWidget = List<CellWidget>();
    for(int r=0; r<row; ++r){
      for(int c=0;c<column;++c){
        _cellWidget.add(CellWidget(cell:_game.get(r,c),state:this));
      }
    }
    _queryData =MediaQuery.of(context);
    List<Widget> children=List<Widget>();
    children.add(BoardGridWidget(this));
    children.addAll(_cellWidget);

    return Scaffold(
      appBar: AppBar(
        title: Expanded(child: MetrKoinLogo(50.0, 50.0)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: colorWhite,
        iconTheme: IconThemeData(color: colorPurple,),
        actions: [PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.more_vert, size: 25.0, color: colorPurple,),
            ),
            onSelected: _onMenuItemSelected,
            itemBuilder: (BuildContext context) {
              return g2048ButtonItems.map((G2048ButtonDropDown mButton) {
                return PopupMenuItem<G2048ButtonDropDown>(
                  value:  mButton,
                  child: Text(mButton.g2048ButtonItems),
                );
              }).toList();
            })],
      ),
      body: Column(
        children: [
          SizedBox(height: 15.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 130.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.nat_outlined, size: 27.0, color: colorBlue),
                      SizedBox(width: 6.0,),
                      Text(_game.score.toString(),
                        style: TextStyle(fontSize: 16.0, color: colorBlack,),
                      ),
                    ]),
              ),
              Container(
                width: 130.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                   //   Image.asset('assets/icons/coin_logo.png', height: 28.0, width: 28.0,),
                      Icon(Icons.emoji_events_outlined, size: 28.0, color: colorRed),
                      SizedBox(width: 6.0,),
                      Text(_game.earning.toString(),
                        style: TextStyle(fontSize: 16.0, color: colorBlack,),
                      ),
                    ]),
              ),
            ],),
          Spacer(flex: 1),
          Container(
              margin: _gameMargin,
              width: _queryData.size.width,
              height: _queryData.size.width,
              child: GestureDetector(
                onVerticalDragUpdate: (detail) {
                  if (detail.delta.distance == 0 || _isDragging) {
                    return;
                  }
                  _isDragging = true;
                  if (detail.delta.direction > 0) {
                    moveDown();
                  } else {
                    moveUp();
                  }
                },
                onVerticalDragEnd: (detail) {
                  _isDragging = false;
                },
                onVerticalDragCancel: () {
                  _isDragging = false;
                },
                onHorizontalDragUpdate: (detail) {
                  if (detail.delta.distance == 0 || _isDragging) {
                    return;
                  }
                  _isDragging = true;
                  if (detail.delta.direction > 0) {
                    moveLeft();
                  } else {
                    moveRight();
                  }
                },
                onHorizontalDragDown: (detail) {
                  _isDragging = false;
                },
                onHorizontalDragCancel: () {
                  _isDragging = false;
                },
                child: Stack(
                  children: children,
                ),
              )),
          Spacer(flex: 2),
          Container(
            height: 60.0,
            margin: EdgeInsets.only(bottom: 5.0),
            child: Center(child: adWidget),
          )
        ])
    );
  }


  Size boardSize() {
    assert(_queryData != null);
    Size size = _queryData.size;
    num width = size.width - _gameMargin.left - _gameMargin.right;
    return Size(width, width);
  }


  _onMenuItemSelected(G2048ButtonDropDown mButton) async {

    if (mButton.g2048ButtonItems == 'new game') {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("You are about to reset the game", style: TextStyle(fontSize: 16.0),),
                content: Text('all progress will be lost',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0)
                ),
                actions: [
                  TextButton(
                    child: Text("dismiss"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  TextButton(
                    child: Text("new game"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ]);
          }).then((val) {
        bool confirm = val;
        if (confirm == true) {
          newGame();
        }
      });
    }
    if (mButton.g2048ButtonItems == 'get hint') {
      _newGame2();
    }
    if (mButton.g2048ButtonItems == 'scoreboard') {
      Get.to(
        Scoreboard2048(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
      );
    }
    if (mButton.g2048ButtonItems == 'exit') {

      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Sure to exit?"),
                content: Text(_game.earning.toString() + '.0000 MTRK will be added to your balance',
                    style: TextStyle(fontSize: 14.0)),
                actions: [
                  TextButton(
                    child: Text("dismiss"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  TextButton(
                    child: Text("exit the game"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ]);
          }).then((val) {
        bool confirm = val;
        if (confirm == true) {
          _isGameOver = true;
          Navigator.pop(context);
        }
      });
    }

  }


}



class BoardGridWidget extends StatelessWidget {

  final _GameWidgetState _state;
  BoardGridWidget(this._state);

  @override
  Widget build(BuildContext context) {
    Size boardSize = _state.boardSize();
    double width = (boardSize.width - (_state.column + 1) * _state.cellPadding) / _state.column;
    List<CellBox> _backgroundBox = List<CellBox>();
    for (int r = 0; r < _state.row; ++r) {
      for (int c = 0; c < _state.column; ++c) {
        CellBox box = CellBox(
          left: c * width + _state.cellPadding * (c + 1),
          top: r * width + _state.cellPadding * (r + 1),
          size: width,
          color: Colors.grey[400],
        //  color: colorButtonGrey,
        );
        _backgroundBox.add(box);
      }
    }
    return Positioned(
        left: 0.0,
        top: 0.0,
        child: Container(
          width: _state.boardSize().width,
          height: _state.boardSize().height,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Stack(
            children: _backgroundBox,
          ),
        )
    );
  }

}



class AnimatedCellWidget extends AnimatedWidget {

  final BoardCell cell;
  BoardCell cell2 = new BoardCell(row: 0);
  final _GameWidgetState state;

  AnimatedCellWidget(
      {Key key, this.cell, this.state, Animation<double> animation})
      : super(key: key, listenable: animation);

  _saveValue(int row, column, number) {

    for (int r=0; r<row; r++) {
      for (int c=0; c<column; c++) {
        print ("Row $r Column $c is : $number");
      }
    }

    // if (row==1 && column==0) {
    //   if (number != null) {
    //     cellBoxOne = number;
    //   } else cellBoxOne = 0;
    //   print ("Row 1 Column 0 is : $cellBoxOne");
    // }
    // if (row==1 && column==1) {
    //   if (number != null) {
    //     cellBoxTwo = number;
    //   } else cellBoxTwo = 0;
    //   print ("Row 1 Column 1 is : $cellBoxTwo");
    // }
    // if (row==1 && column==2) {
    //   if (number != null) {
    //     cellBoxThree = number;
    //   }
    //   else cellBoxThree = 0;
    //   print ("Row 1 Column 2 is : $cellBoxThree");
    // }
    // if (row==1 && column==3) {
    //   if (number != null) {
    //     cellBoxFour = number;
    //   } else cellBoxFour = 0;
    //   print ("Row 1 Column 3 is : $cellBoxFour");
    // }
    // if (row==2 && column==0) {
    //   if (number != null) {
    //     cellBoxFive = number;
    //   } else cellBoxFive = 0;
    //   print ("Row 2 Column 0 is : $cellBoxFive");
    // }
    // if (row==2 && column==1) {
    //   if (number != null) {
    //     cellBoxSix = number;
    //   } else cellBoxSix = 0;
    //   print ("Row 2 Column 1 is : $cellBoxSix");
    // }
    // if (row==2 && column==2) {
    //   if (number != null) {
    //     cellBoxSeven = number;
    //   } else cellBoxSeven = 0;
    //   print ("Row 2 Column 2 is : $cellBoxSeven");
    // }
    // if (row==2 && column==3) {
    //   if (number != null) {
    //     cellBoxEight = number;
    //   } else cellBoxEight = 0;
    //   print ("Row 2 Column 3 is : $cellBoxEight");
    // }
    // if (row==3 && column==0) {
    //   if (number != null) {
    //     cellBoxNine = number;
    //   } else cellBoxNine = 0;
    //   print ("Row 3 Column 0 is : $cellBoxNine");
    // }
    // if (row==3 && column==1) {
    //   if (number != null) {
    //     cellBoxTen = number;
    //   } else cellBoxTen = 0;
    //   print ("Row 3 Column 1 is : $cellBoxTen");
    // }
    // if (row==3 && column==2) {
    //   if (number != null) {
    //     cellBoxEleven = number;
    //   } else cellBoxEleven = 0;
    //   print ("Row 3 Column 2 is : $cellBoxEleven");
    // }
    // if (row==3 && column==3) {
    //   if (number != null) {
    //     cellBoxTwelve = number;
    //   } else cellBoxTwelve = 0;
    //   print ("Row 3 Column 3 is : $cellBoxTwelve");
    // }

  }


  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.cellPadding) /
        state.column;
    if (cell.number == 0) {
      return Container();
    } else {
      _saveValue(cell.row, cell.column, cell.number);

      return CellBox(
        left: (cell.column * width + state.cellPadding * (cell.column + 1)) +
            width / 2 * (1 - animationValue),
        top: cell.row * width +
            state.cellPadding * (cell.row + 1) + width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: boxColor.containsKey(cell.number)
            ? boxColor[cell.number] : boxColor[boxColor.keys.last],
        text: Text(
          cell.number.toString(),
          style: TextStyle(
            fontSize: 30.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: colorWhite
          ),
        ),
      );
    }
  }

}




class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final _GameWidgetState state;
  CellWidget({this.cell, this.state});
  _CellWidgetState createState() => _CellWidgetState();
}


class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCellWidget(
      cell: widget.cell,
      state: widget.state,
      animation: animation,
    );
  }
}
