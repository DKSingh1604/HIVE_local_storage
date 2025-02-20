// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get the box
  final _myBox = Hive.box("MY_BOX");

  
  final _textController = TextEditingController();

  
  List todos = [];

  @override
  void initState() {
    // load data, if none exists then default to empty list
    todos = _myBox.get("TODO_LIST") ?? [];

    super.initState();
  }

  //open new todo dialog
  void openNewTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Task"),
        content: TextField(
          controller: _textController,
          decoration: InputDecoration(hintText: "Enter Task"),
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              //clear text field
              _textController.clear();
            },
            child: Text("Cancel"),
          ),

          //add button
          TextButton(
            onPressed: () {
              //pop the box
              Navigator.pop(context);

              addTodo();
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  //add new todo
  void addTodo() {
    String todo = _textController.text;
    setState(() {
      todos.add(todo);
      _textController.clear();
    });
    saveToDatabase();
  }

  //delete todo
  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    saveToDatabase();
  }

  //save to database
  void saveToDatabase() {
    _myBox.put("TODO_LIST", todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO List"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNewTodo,
        child: Icon(Icons.add),
      ),
      //display list of TODOS
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          //get each todo
          final todo = todos[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(todo),
                trailing: IconButton(
                  onPressed: () => deleteTodo(index),
                  icon: Icon(Icons.delete),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
