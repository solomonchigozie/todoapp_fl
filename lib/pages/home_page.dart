import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/utils/dialog_box.dart';
import 'package:todoapp/utils/todo_tile.dart';

class HomePageState extends StatefulWidget {
  const HomePageState({super.key});

  @override
  State<HomePageState> createState() => _HomePageStateState();
}

class _HomePageStateState extends State<HomePageState> {
  //reference the hive box
  final _mybox = Hive.box('myBox');

  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    //if this is the first time opening the app, create data
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      //a data already exist
      db.loadData();
    }

    super.initState();
  }

  //text controller
  final _controller = TextEditingController();

  //list of todo tasks
  // List toDoLists = [
  //   ["make lecture", false],
  //   ["Do exercise", false],
  // ];

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoLists[index][1] = !db.toDoLists[index][1];
    });

    //update databse
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoLists.add([_controller.text, false]);
      //clear text from dialog textbox
      _controller.clear();
    });
    Navigator.of(context).pop();
    //update database
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoLists.removeAt(index);
    });
    //update database
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Center(child: Text('TO DO')),
        elevation: 0,
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoLists.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.toDoLists[index][0],
            taskCompleted: db.toDoLists[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
