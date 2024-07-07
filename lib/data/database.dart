import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List toDoLists = [];

  //reference the box
  final _myBox = Hive.box('myBox');

  //run if the first time opening the app

  void createInitialData() {
    toDoLists = [
      ['Make cofee', false],
      ['Write a book', false]
    ];
  }

  //load data from database
  void loadData() {
    toDoLists = _myBox.get("TODOLIST");
  }

  //update the database
  void updateDatabase() {
    _myBox.put("TODOLIST", toDoLists);
  }
}
