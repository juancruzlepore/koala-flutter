import 'package:flutter/material.dart';
import 'package:koala/todo/ToDoGroup.dart';
import 'ToDoElement.dart';

class ToDoListWidget extends StatefulWidget {
  ToDoListWidget({Key key}) : super(key: key);

  @override
  _ToDoListWidgetState createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  var elements = [
    ToDoElementWidget(ToDoElement("primero")),
    ToDoElementWidget(ToDoElement("segundo")),
    ToDoElementWidget(ToDoElement("tercero")),
    ToDoGroupWidget(ToDoGroup("group!")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Column(
                children: <Widget> [ for(var e in elements)
                  e
                ]
            )],
        ),
      ),
    );
  }
}
