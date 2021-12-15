 import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrkoin/screens/game_arena/sudoku/state/hive/sudoku_type_adapter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

import 'hive/level_type_adapter.dart';
import 'package:sprintf/sprintf.dart';

part 'sudoku_state.g.dart';


const LEVEL_NAMES = {
  LEVEL.EASY: "EASY",
  LEVEL.MEDIUM: "MEDIUM",
  LEVEL.HARD: "HARD",
  LEVEL.EXPERT: "EXPERT"
};

const STATUS_NAMES = {
  SudokuGameStatus.initialize: "initialization",
  SudokuGameStatus.gaming: "gaming",
  SudokuGameStatus.pause: "pause",
  SudokuGameStatus.fail: "fail",
  SudokuGameStatus.success: "success"
};

@HiveType(typeId: 6)
enum SudokuGameStatus {
  @HiveField(0)
  initialize,

  @HiveField(1)
  gaming,

  @HiveField(2)
  pause,

  @HiveField(3)
  fail,

  @HiveField(4)
  success
}

@HiveType(typeId: 5)
class SudokuState extends Model {
  @HiveField(0)
  SudokuGameStatus status;

  // 数独
  @HiveField(1)
  Sudoku sudoku;

  // Difficulty level
  @HiveField(2)
  LEVEL level;

  // time consuming
  @HiveField(3)
  int timing;

  // Available life
  @HiveField(4)
  int life;

  // Available hints
  @HiveField(5)
  int hint;

  // game_arena Fill in the record
  @HiveField(6)
  List<int> record;

  // notes
  @HiveField(7)
  List<List<bool>> mark;

  // isComplete
  bool get isComplete {
    if(sudoku == null){
      return false;
    }

    int value ;
    for(int i =0 ;i<81;++i){
      value = sudoku.puzzle[i];
      if(value == -1){
        value = record[i];
      }
      if(value == -1){
        return false;
      }
    }

    return true;
  }

  SudokuState({LEVEL level, Sudoku sudoku}) {
    print("SudokuState Initialized ???");
    print("level : $level");
    initialize(level: level, sudoku: sudoku);
  }

  static SudokuState newSudokuState({LEVEL level, Sudoku sudoku}) {
    SudokuState state = new SudokuState(level: level, sudoku: sudoku);
    return state;
  }

  void initialize({LEVEL level, Sudoku sudoku}) {
    status = SudokuGameStatus.initialize;
    this.sudoku = sudoku;
    this.level = level;
    timing = 0;
    if(level == LEVEL.EASY) {
      life = 20;
      hint = 5;
    }
    if(level == LEVEL.MEDIUM) {
      life = 15;
      hint = 4;
    }
    if(level == LEVEL.HARD) {
      life = 10;
      hint = 3;
    }
    if(level == LEVEL.EXPERT) {
      life = 5;
      hint = 2;
    }
    record = List.generate(81, (index) => -1);
    mark = List.generate(81, (index) => null);
    notifyListeners();
  }

  void tick() {
    this.timing = (this.timing ?? 0) + 1;
    notifyListeners();
  }

  String get timer => sprintf("%02i:%02i", [timing ~/ 60, timing % 60]);

  void lifeLoss() {
    if (this.life > 0) {
      this.life--;
    }
    if (this.life <= 0) {
      this.status = SudokuGameStatus.fail;
    }
    notifyListeners();
  }

  void hintLoss() {
    if (this.hint ?? 0 > 0) {
      this.hint--;
    }
    notifyListeners();
  }

  void setRecord(int index, int num) {
    if (index < 0 || index > 80 || num < 0 || num > 9) {
      throw new ArgumentError(
          'index border [0,80] num border [0,9] , input index:$index | num:$num out of the border');
    }
    if (this.status == SudokuGameStatus.initialize) {
      throw new ArgumentError("can't update record in \"initialize\" status");
    }
    List<int> puzzle = this.sudoku.puzzle;

    // 清空笔记
    cleanMark(index);

    if (puzzle[index] != -1) {
      this.record[index] = -1;
      return;
    }
    this.record[index] = num;

    /// Update filling records, clear notes
    /// Clear current index notes
    /// Remove zone row col 中的对应笔记

    List<int> colIndexes = Matrix.getColIndexes(Matrix.getCol(index));
    List<int> rowIndexes = Matrix.getRowIndexes(Matrix.getRow(index));
    List<int> zoneIndexes =
        Matrix.getZoneIndexes(zone: Matrix.getZone(index: index));

    colIndexes.forEach((_) {
      cleanMark(_, num: num);
    });
    rowIndexes.forEach((_) {
      cleanMark(_, num: num);
    });
    zoneIndexes.forEach((_) {
      cleanMark(_, num: num);
    });

    notifyListeners();
  }

  void cleanRecord(int index) {
    if (this.status == SudokuGameStatus.initialize) {
      throw new ArgumentError("can't update record in \"initialize\" status");
    }
    List<int> puzzle = this.sudoku.puzzle;
    if (puzzle[index] == -1) {
      this.record[index] = -1;
    }
    notifyListeners();
  }

  void switchRecord(int index,int num){
    if (index < 0 || index > 80 || num < 0 || num > 9) {
      throw new ArgumentError(
          'index border [0,80] num border [0,9] , input index:$index | num:$num out of the border');
    }
    if (this.status == SudokuGameStatus.initialize) {
      throw new ArgumentError("can't update record in \"initialize\" status");
    }
    if(sudoku.puzzle[index] != -1){
      return ;
    }
    if(record[index] == num){
      cleanRecord(index);
    }else{
      setRecord(index, num);
    }
  }

  void setMark(int index, int num) {
    if (index < 0 || index > 80) {
      throw new ArgumentError(
          'index border [0,80], input index:$index out of the border');
    }
    if (num == null || num < 1 || num > 9) {
      throw new ArgumentError("num must be [1,9]");
    }
    // Clear number
    cleanRecord(index);

    if (sudoku.puzzle[index] != -1) {
      this.mark[index] = null;
      return;
    }

    List<bool> markPoint = this.mark[index];
    if (markPoint == null) {
      markPoint = List.generate(10, (index) => false);
    }
    markPoint[num] = true;
    this.mark[index] = markPoint;
    notifyListeners();
  }

  void cleanMark(int index, {int num}) {
    if (index < 0 || index > 80) {
      throw new ArgumentError(
          'index border [0,80], input index:$index out of the border');
    }
    List<bool> markPoint = this.mark[index];
    if (markPoint != null) {
      if (num != null && num > 0 && num < 10) {
        markPoint[num] = false;
        if (!markPoint.contains(true)) {
          markPoint = null;
        }
      } else {
        markPoint = null;
      }

      this.mark[index] = markPoint;
    }
    notifyListeners();
  }

  void switchMark(int index, int num) {
    if (index < 0 || index > 80) {
      throw new ArgumentError(
          'index border [0,80], input index:$index out of the border');
    }
    if (num == null || num < 1 || num > 9) {
      throw new ArgumentError("num must be [1,9]");
    }

    List<bool> markPoint = this.mark[index];
    if(markPoint == null ){
      markPoint = List.generate(10, (index) => false);
    }
    if (!markPoint[num]) {
      setMark(index, num);
    } else {
      cleanMark(index, num: num);
    }
  }

  void updateSudoku(Sudoku sudoku) {
    this.sudoku = sudoku;
//    notifyListeners();
  }

  void updateStatus(SudokuGameStatus status) {
    this.status = status;
    notifyListeners();
  }

  void updateLevel(LEVEL level) {
    this.level = level;
    notifyListeners();
  }

  // Check if the number is still in stock(判断是否填写满)
  bool hasNumStock(int num){
    if(sudoku == null){
      return false;
    }
    int puzzleLength = sudoku.puzzle.where((element) => element == num).length;
    int recordLength = record.where((element) => element == num).length;
    return 9 > (puzzleLength + recordLength);
  }

  static const String HIVE_BOX_NAME = "game_arena.store";
  static const String HIVE_STATE_NAME = "state";

  void persistent() async {
    await _initHive();
    var sudokuStore = await Hive.openBox(HIVE_BOX_NAME);
    await sudokuStore.put(HIVE_STATE_NAME, this);
    if(sudokuStore.isOpen){
      await sudokuStore.compact();
      await sudokuStore.close();
    }

  }

  static Future<SudokuState> resumeFromDB() async {
    await _initHive();

    SudokuState state;
    Box sudokuStore;

    try {
      sudokuStore = await Hive.openBox(HIVE_BOX_NAME);
      state = sudokuStore.get(HIVE_STATE_NAME,
          defaultValue: SudokuState.newSudokuState());
    } catch (e) {
      print(e);
      state = SudokuState.newSudokuState();
    } finally{
      if(sudokuStore.isOpen){
        await sudokuStore.close();
      }
    }

    return state;
  }

  static _initHive() async {
    if (!await Hive.boxExists(HIVE_BOX_NAME)) {
      await Hive.initFlutter();
      Hive.registerAdapter<Sudoku>(SudokuAdapter());
      Hive.registerAdapter<SudokuState>(SudokuStateAdapter());
      Hive.registerAdapter<SudokuGameStatus>(SudokuGameStatusAdapter());
      Hive.registerAdapter<LEVEL>(SudokuLevelAdapter());
    }
  }
}
