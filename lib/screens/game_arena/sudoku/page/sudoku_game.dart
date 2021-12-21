import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metrkoin/models/game_arena/sudoku_drop_down_items.dart';
import 'package:metrkoin/screens/game_arena/sudoku/page/bootstrap.dart';
import 'package:metrkoin/screens/game_arena/sudoku/page/sudoku_pause_cover.dart';
import 'package:metrkoin/screens/game_arena/sudoku/state/sudoku_state.dart';
import 'package:metrkoin/screens/game_arena/sudoku/sudoku_info.dart';
import 'package:metrkoin/services/ad_helper.dart';
import 'package:metrkoin/services/api_calls.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';
import 'package:metrkoin/utils/timestamp.dart';
import 'package:metrkoin/utils/toast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_dart/sudoku_dart.dart';



class SudokuGamePage extends StatefulWidget {

  @override
  _SudokuGamePageState createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends State<SudokuGamePage>
    with WidgetsBindingObserver {

  int _chooseSudokuBox = 0;
  bool _markOpen = false;
  bool _manualPause = false;

  Timer _timer;
  AdListener listenerT = AdListener();
  SudokuState get _state => ScopedModel.of<SudokuState>(context);
  bool _isOnlyReadGrid(int index) => _state.sudoku.puzzle[index] != -1;


  @override
  void dispose() {
    print("on dispose");
    _pauseTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    _gaming();
    myBanner.load();
    hintAdReward.load();
    lifeAdReward.load();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        print("is paused app lifecycle state");
        _pause();
        break;
      case AppLifecycleState.resumed:
        print("is resumed app lifecycle state");
        if (!_manualPause) {
          _gaming();
        }
        break;
      default:
        break;
    }
  }

  void _gaming() {
    if (_state.status == SudokuGameStatus.pause) {
      print("on _gaming");
      _state.updateStatus(SudokuGameStatus.gaming);
      _state.persistent();
      _beginTimer();
    }
  }

  void _pause() {
    if (_state.status == SudokuGameStatus.gaming) {
      print("on _pause");
      _state.updateStatus(SudokuGameStatus.pause);
      _state.persistent();
      _pauseTimer();
    }
  }

  void _beginTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_state.status == SudokuGameStatus.gaming) {
          _state.tick();
          if (_state.level==LEVEL.EASY && _state.timing==1200) {
            _gameOver();
          }
          if (_state.level==LEVEL.MEDIUM && _state.timing==960) {
            _gameOver();
          }
          if (_state.level==LEVEL.HARD && _state.timing==720) {
            _gameOver();
          }
          if (_state.level==LEVEL.EXPERT && _state.timing==480) {
            _gameOver();
          }
          return;
        }
        timer.cancel();
      });
    }
  }

  void _pauseTimer() {
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {

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
                return menuButtonItems.map((MenuButtonDropDown mButton) {
                  return PopupMenuItem<MenuButtonDropDown>(
                    value:  mButton,
                    child: Text(mButton.menuButtonItems),
                  );
                }).toList();
              })],
      ),
      body: _willPopWidget(
        context,
        ScopedModelDescendant<SudokuState> (
          builder: (context, child, model) => _bodyWidget(context)
        ), () async {
          _pause();
          return true;
      }),
    );
  }


  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.sudokuGameBannerAdUnit,
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener(),
  );


  final RewardedAd hintAdReward = RewardedAd(
    adUnitId: AdHelper.sudokuHintAdUnit,
    request: AdRequest(),
    listener: AdListener(
      onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        print(reward.type);
        print(reward.amount);
      },
    ),
  );


  final RewardedAd lifeAdReward = RewardedAd(
    adUnitId: AdHelper.sudokuLifeAdUnit,
    request: AdRequest(),
    listener: AdListener(),
  );


  void _gameOver() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    bool isWinner = _state.status == SudokuGameStatus.success;
    String title, conclusion;
    int rewardAmount;
    setState(() {
      if (_state.level == LEVEL.EASY) rewardAmount = 1000;
      if (_state.level == LEVEL.MEDIUM) rewardAmount = 1500;
      if (_state.level == LEVEL.HARD) rewardAmount = 2000;
      if (_state.level == LEVEL.EXPERT) rewardAmount = 2500;
    });
    if (isWinner) {
      title = "Good Job!";
      conclusion = "Congratulations on your completion of the Sudoku Challenge";
      List<String> sudokuGameSavedData = [getTimestamp(), rewardAmount.toString()];
      prefs.setStringList('sudoku_game_saved_data', sudokuGameSavedData);
      var result = await updateUserBalanceForSudoku(userId, getTimestamp(), rewardAmount);
      if (result == true) {
        prefs.remove('sudoku_game_saved_data');
      }
    } else {
      title = "Game Over";
      conclusion = "Unfortunately, you have lost this round of Sudoku Challenge, please try again";
    }

    Navigator.of(context)
        .push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Scaffold(
              backgroundColor: Colors.white.withOpacity(0.80),
              body: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(title,
                                  style: TextStyle(
                                      color: isWinner ? Colors.black : Colors.redAccent,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)))),
                      Expanded(
                          flex: 2,
                          child: Column(children: [
                            Text(conclusion, style: TextStyle(fontSize: 15)),
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                child: Text("Duration  ${_state.timer}'s",
                                    style: TextStyle(color: Colors.blue))),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.thumb_up),
                                          onPressed: () {
                                            Navigator.pop(context, "share");
                                          }),
                                      IconButton(
                                          icon: Icon(Icons.exit_to_app),
                                          onPressed: () {
                                            Navigator.pop(context, "exit");
                                          })
                                    ]))
                          ]))
                    ],
                  )));
        }))
        .then((value) {
      String signal = value;
      switch (signal) {
        case "ad":
          break;
        case "exit":
        default:
          Navigator.pop(context);
          break;
      }
    });
  }


  Widget _fillZone(BuildContext context) {
    List<Widget> fillTools = List.generate(9, (index) {
      int num = index + 1;
      bool hasNumStock = _state.hasNumStock(num);
      var fillOnPressed = !hasNumStock ? null : () {
        if (_isOnlyReadGrid(_chooseSudokuBox)) {
          // Non-fill-in-the-blank
          return;
        }
        if (_state.status != SudokuGameStatus.gaming) {
          return;
        }
        if (_markOpen) {
          // Fill in notes
          _state.switchMark(_chooseSudokuBox, num);
        } else {
          // Fill in the numbers
          _state.switchRecord(_chooseSudokuBox, num);
          // Judging the authenticity
          if (_state.record[_chooseSudokuBox] != -1 &&
              _state.sudoku.answer[_chooseSudokuBox] != num) {

            // Fill in the wrong number
            _state.lifeLoss();
            if (_state.life <= 0) {
              // game over
              return _gameOver();
            }
            return;
          }
          // Judging the progress
          if (_state.isComplete) {
            _pauseTimer();
            _state.updateStatus(SudokuGameStatus.success);
            return _gameOver();
          }
        }
      };

      return Expanded(
        flex: 1,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: CupertinoButton(
                color: colorBlueIcon,
                padding: EdgeInsets.all(1.5),
                child: Text('${index + 1}', style: TextStyle(
                    color: colorWhite,
                    fontSize: 20, fontWeight: FontWeight.w600)),
                onPressed: fillOnPressed
            )
        ),
      );
    });

    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Row(children: fillTools)
        )
    );
  }

  Widget _markGridWidget(BuildContext context, int index, Function onTap) {
    Widget markGrid = InkWell(
        highlightColor: Colors.blue,
        customBorder: Border.all(color: Colors.blue),
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: _gridInWellBgColor(index),
                border: Border.all(color: Colors.black12)),
            child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int _index) {
                  String markNum =
                      '${_state.mark[index][_index + 1] ? _index + 1 : ""}';
                  return Text(markNum,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _chooseSudokuBox == index
                              ? Colors.white
                              : Color.fromARGB(255, 0x16, 0x85, 0xA9),
                          fontSize: 12));
                })));

    return markGrid;
  }

  Widget _bodyWidget(BuildContext context) {
    AdWidget adWidget = AdWidget(ad: myBanner);

    if (_state.sudoku == null) {
      return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Center(
              child: Text('Sudoku Exiting...', style: TextStyle(color: Colors.black))
          )
      );
    }
    return Container(
      color: colorWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.timer, size: 18.0, color: colorPurple,),
                  SizedBox(width: 6.0,),
                  Text(_state.timer, style: TextStyle(fontSize: 16.0),),
                ] )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Image.asset('assets/images/icon_life.png', width: 20.0, height: 20.0,),
                        Text(" x ${_state.life}", style: TextStyle(fontSize: 16))
                    ]),
                  ),
                  SizedBox(width: 44.0,),
                  Expanded(
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset('assets/images/icon_idea.png', height: 20.0, width: 20.0,),
                            Text(" x ${_state.hint}",
                                style: TextStyle(fontSize: 18))
                          ]),
                      onTap: () {
                        if (_state.hint >= 1) {
                          _state.switchRecord(_chooseSudokuBox, _state.sudoku.answer[_chooseSudokuBox]);
                          if (_chooseSudokuBox != null) {
                            setState(() {
                              _state.hint --;
                            });
                          }
                        }
                        else {
                          toastMessage("you have 0 hints \nsecure more hints with get hints");
                        }
                      },
                    ),
                  ),

              ]),
          ),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 81,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
              itemBuilder: ((BuildContext context, int index) {
                int num = -1;
                if (_state.sudoku?.puzzle?.length == 81) {
                  num = _state.sudoku.puzzle[index];
                }
                wellOnTap() {
                  setState(() {
                    _chooseSudokuBox = index;
                  });

                  if (num != -1) return;
                }

                // User-marked
                bool isUserMark = _state.sudoku.puzzle[index] == -1 &&
                    _state.mark[index] != null &&
                    _state.mark[index].isNotEmpty;

                if (isUserMark) {
                  return _markGridWidget(context, index, wellOnTap);
                }

                return _gridInWellWidget(context, index, num, wellOnTap);
              })
          ),
          Container(
            height: 80.0,
            child: _fillZone(context)),
          Spacer(flex: 1),
          Container(
            height: 60.0,
            margin: EdgeInsets.only(bottom: 5.0),
            child: Center(child: adWidget),
          )
        ] ),
    );
  }


  _rewardUserForLifeAds() {
    if (_state.level==LEVEL.EASY || _state.level==LEVEL.MEDIUM) {
      setState(() => _state.life += 4);
    }
    if (_state.level==LEVEL.HARD || _state.level==LEVEL.EXPERT) {
      setState(() => _state.life += 2);
    }
  }

  _rewardUserForHintAds() {
    if (_state.level==LEVEL.EASY || _state.level==LEVEL.MEDIUM) {
      setState(() => _state.hint += 2);
    }
    if (_state.level==LEVEL.HARD || _state.level==LEVEL.EXPERT) {
      setState(() => _state.hint += 1);
    }
  }

  _onMenuItemSelected(MenuButtonDropDown mButton) async {

    if (mButton.menuButtonItems == 'pause'){
      if (_state.status != SudokuGameStatus.gaming) return
      setState(() => _manualPause = true);
      _pause();
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return SudokuPauseCoverPage();
              })).then((_) {
                _gaming();
                setState(() => _manualPause = false);
      });
    }
    if (mButton.menuButtonItems == 'new game'){
      await sudokuGenerate(context, _state.level).then((value) {
        initState();
        toastMessage('Sudoku reloaded');
      });
    }
    if (mButton.menuButtonItems == 'get hint'){
      hintAdReward.show();
      await hintAdReward.show().then((value) => _rewardUserForHintAds());
    }
    if (mButton.menuButtonItems == 'redeem life'){
      await lifeAdReward.show().then((value) => _rewardUserForLifeAds());
    }
    if (mButton.menuButtonItems == 'info'){
      Get.to(
        SudokuInfo(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
      );
    }
    if (mButton.menuButtonItems == 'exit') {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Sure to exit?"),
                content: Text("All progress will be lost",
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
          ScopedModel.of<SudokuState>(context).initialize();
          Navigator.pop(context);
        }
      });
    }
  }


  Widget _willPopWidget(
      BuildContext context, Widget child, Function onWillPop) {
    return new WillPopScope(child: child, onWillPop: onWillPop);
  }

  Color _gridInWellBgColor(int index) {
    Color gridWellBackgroundColor;
    // Tong Gong
    List<int> zoneIndexes = Matrix.getZoneIndexes(zone: Matrix.getZone(index: index));
    // Accompany
    List<int> rowIndexes = Matrix.getRowIndexes(Matrix.getRow(index));
    // In the same line
    List<int> colIndexes = Matrix.getColIndexes(Matrix.getCol(index));

    Set indexSet = Set();
    indexSet.addAll(zoneIndexes);
    indexSet.addAll(rowIndexes);
    indexSet.addAll(colIndexes);

    if (index == _chooseSudokuBox) {
      gridWellBackgroundColor = Color.fromARGB(255, 0x70, 0xF3, 0xFF);
    } else if (indexSet.contains(_chooseSudokuBox)) {
      gridWellBackgroundColor = Color.fromARGB(255, 0x44, 0xCE, 0xF6);
    } else {
      if (Matrix.getZone(index: index).isOdd) {
        gridWellBackgroundColor = Colors.white;
      } else {
        gridWellBackgroundColor = Color.fromARGB(255, 0xCC, 0xCC, 0xCC);
      }
    }
    return gridWellBackgroundColor;
  }

  Widget _gridInWellWidget(BuildContext context, int index,
      int num, Function onTap) {
    Sudoku sudoku = _state.sudoku;
    List<int> puzzle = sudoku.puzzle;
    List<int> answer = sudoku.answer;
    List<int> record = _state.record;
    bool readOnly = true;
    bool isWrong = false;
    int num = puzzle[index];
    if (puzzle[index] == -1) {
      num = record[index];
      readOnly = false;

      if (record[index] != -1 && record[index] != answer[index]) {
        isWrong = true;
      }
    }
    return InkWell(
        highlightColor: Colors.blue,
        customBorder: Border.all(color: Colors.blue),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: _gridInWellBgColor(index),
                border: Border.all(color: Colors.black12)),
            child: Text(
              '${num == -1 ? '' : num}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: readOnly ? FontWeight.w800 : FontWeight.normal,
                  color: readOnly
                      ? Colors.blueGrey
                      : (isWrong
                      ? Colors.red
                      : Color.fromARGB(255, 0x3B, 0x2E, 0x7E))),
            ),
          ),
        ),
        onTap: onTap);
  }



}
