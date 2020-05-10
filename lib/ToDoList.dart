import 'package:flutter/material.dart';
import 'package:koala/ToDoGroup.dart';
import 'ToDoElement.dart';

class ToDoListWidget extends StatefulWidget {
  ToDoListWidget({Key key, this.title}) : super(key: key);

  final String title;

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
