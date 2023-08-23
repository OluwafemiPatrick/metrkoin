import 'dart:math' show Random;

import 'package:metrkoin/screens/game_arena/2048/g2048_getter_and_setter.dart';
import 'package:metrkoin/utils/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game {
  final int row;
  final int column;

  late int score;
  late int earning;
  late List<List<BoardCell>> _boardCells;

  Game({required this.row, required this.column});


  void init() {
    for (int r = 0; r < row; ++r) {
      // _boardCells = [];
      // _boardCells.add(List<BoardCell>());
      for (int c = 0; c < column; ++c) {
        _boardCells[r].add(BoardCell(
          row: r,
          column: c,
          number: 0,
          isNew: false,
        ));
      }
    }
    print ('BOARD CELL LENGTH IS ' + _boardCells.length.toString());
    score = 0;
    earning = 0;
    resetMergeStatus();
    randomEmptyCell(2);
  }


  void init2(int scoreH, earningH) {
    List<BoardCell> emptyCells = <BoardCell>[];
    _boardCells.forEach((cells) {
      emptyCells.addAll(cells.where((cell) {
        return cell.isEmpty();
      }));
    });

    _boardCells = <List<BoardCell>>[];
    for (int r = 0; r < row; ++r) {
      _boardCells.add(<BoardCell>[]);
      for (int c = 0; c < column; ++c) {
        _boardCells[r].add(BoardCell(
          row: r,
          column: c,
          number: 0,
          isNew: false,
        ));
      }
    }
    score = scoreH;
    earning = earningH;
    resetTopRow();
    resetMergeStatus();
  }


  BoardCell get(int r, int c) {
    return _boardCells[r][c];
  }

  void moveLeft() {
    if (!canMoveLeft()) {
      return;
    }
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeLeft(r, c);
      }
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  void moveRight() {
    if (!canMoveRight()) {
      return;
    }
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        mergeRight(r, c);
      }
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  void moveUp() {
    if (!canMoveUp()) {
      return;
    }
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeUp(r, c);
      }
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  void moveDown() {
    if (!canMoveDown()) {
      return;
    }
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        mergeDown(r, c);
      }
    }
    randomEmptyCell(1);
    resetMergeStatus();
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; ++r) {
      for (int c = 1; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        if (canMerge(_boardCells[r][c], _boardCells[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(_boardCells[r][c], _boardCells[r][c - 1]);
      c--;
    }
  }

  void mergeRight(int r, int c) {
    while (c < column - 1) {
      merge(_boardCells[r][c], _boardCells[r][c + 1]);
      c++;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(_boardCells[r][c], _boardCells[r - 1][c]);
      r--;
    }
  }

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      merge(_boardCells[r][c], _boardCells[r + 1][c]);
      r++;
    }
  }

  bool canMerge(BoardCell a, BoardCell b) {
    return !b.isMerged &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void merge(BoardCell a, BoardCell b) {
    if (!canMerge(a, b)) {
      if (!a.isEmpty() && !b.isMerged) {
        b.isMerged = true;
      }
      return;
    }

    if (b.isEmpty()) {
      b.number = a.number;
      a.number = 0;
    }
    else if (a == b) {
      print ('VALUE OF A IS ' + a.number.toString());
      print ('VALUE OF B IS ' + b.number.toString());
      b.number = b.number * 2;
      a.number = 0;
      score += b.number;
      b.isMerged = true;
      updateEarning();
    } else {
      b.isMerged = true;
    }
  }

  bool isGameOver() {
    return !canMoveLeft() && !canMoveRight() && !canMoveUp() && !canMoveDown();
  }


  void updateEarning() {
    if (score>=64 && earning<16) {
      earning += 16;
      saveDataToSharedPref();
    }
    if (score>=128 && earning<48) {
      earning += 32;
      saveDataToSharedPref();
    }
    if (score>=256 && earning<112) {
      earning += 64;
      saveDataToSharedPref();
    }
    if (score>=512 && earning<368) {
      earning += 256;
      saveDataToSharedPref();
    }
    if (score>=1024 && earning<1392) {
      earning += 1024;
      saveDataToSharedPref();
    }
    if (score>=2048 && earning<3440) {
      earning += 2048;
      saveDataToSharedPref();
    }
  }


  void saveDataToSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('g2048Earning', earning.toString());
    prefs.setString('g2048TimeStamp', getTimestamp());
  }


  void resetTopRow() {
    List<BoardCell> emptyCells = <BoardCell>[];
    _boardCells.forEach((cells) {
      emptyCells.addAll(cells.where((cell) {
        return cell.isEmpty();
      }));
    });
    emptyCells[0].number = 0;
    emptyCells[1].number = 0;
    emptyCells[2].number = 0;
    emptyCells[3].number = 0;

    print ('CELL NUMBER 1 IS ' + cellBoxOne.toString());
    print ('CELL NUMBER 2 IS ' + cellBoxTwo.toString());
    print ('CELL NUMBER 3 IS ' + cellBoxThree.toString());
    print ('CELL NUMBER 4 IS ' + cellBoxFour.toString());
    print ('CELL NUMBER 5 IS ' + cellBoxFive.toString());
    print ('CELL NUMBER 6 IS ' + cellBoxSix.toString());
    print ('CELL NUMBER 7 IS ' + cellBoxSeven.toString());
    print ('CELL NUMBER 8 IS ' + cellBoxEight.toString());
    print ('CELL NUMBER 9 IS ' + cellBoxNine.toString());
    print ('CELL NUMBER 10 IS ' + cellBoxTen.toString());
    print ('CELL NUMBER 11 IS ' + cellBoxEleven.toString());
    print ('CELL NUMBER 12 IS ' + cellBoxTwelve.toString());

  }


  void randomEmptyCell(int cnt) {
    List<BoardCell> emptyCells = <BoardCell>[];
    _boardCells.forEach((cells) {
      emptyCells.addAll(cells.where((cell) {
        return cell.isEmpty();
      }));
    });
    if (emptyCells.isEmpty) {
      return;
    }
    Random r = Random();
    for (int i = 0; i < cnt && emptyCells.isNotEmpty; i++) {

      int index = r.nextInt(emptyCells.length);
      emptyCells[index].number = randomCellNum();
      emptyCells[index].isNew = true;
      emptyCells.removeAt(index);
    }
  }


  int randomCellNum() {
    final Random r = Random();
    return r.nextInt(15) == 0 ? 4 : 2;
  }

  void resetMergeStatus() {
    _boardCells.forEach((cells) {
      cells.forEach((cell) {
        cell.isMerged = false;
      });
    });
  }
}


class BoardCell {

  int row, column;
  int number = 0;
  bool isMerged = false;
  bool isNew = false;

  BoardCell({required this.row, required this.column, required this.number, required this.isNew});

  bool isEmpty() {
    return number == 0;
  }

  @override
  int get hashCode {
    return number.hashCode;
  }

  @override
  bool operator ==(other) {
    return other is BoardCell && number == other.number;
  }

}
