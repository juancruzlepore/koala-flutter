import 'package:flutter/material.dart';

class ToDoElement {
  String name;
  bool done;
  bool editing;

  ToDoElement(String name){
    this.name = name;
    this.done = false;
    this.editing = false;
  }

  ToDoElement._editable(){
    this.name = '';
    this.done = false;
    this.editing = true;
  }

  static ToDoElement buildEditable(){
    return ToDoElement._editable();
  }

  bool isDone() {
    return done;
  }

  bool toggle() {
    return done = !done;
  }
}

class ToDoElementWidget extends StatefulWidget {

  final ToDoElement e;

  ToDoElementWidget(this.e);

  @override
  State<StatefulWidget> createState() {
    return _ToDoElementWidgetState(e);
  }
}

class _ToDoElementWidgetState extends State<ToDoElementWidget> {

  ToDoElement e;
  TextField titleText;

  _ToDoElementWidgetState(ToDoElement element){
    this.e = element;
    titleText = TextField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title'
      ),
      style: TextStyle(fontSize: 22),
      onChanged: updateTitle,
    );
  }

  void addElement(){
    this.setState((){
      e.editing = false;
    });
  }

  void updateTitle(text){
    e.name = text;
  }

  Widget buildNormal(){
    return ListTile(title:
    Row( children: <Widget> [
      Expanded(child: Text('${e.name}', style: TextStyle(fontSize: 22))),
//      Expanded(child: Container()),
      Container(child: Checkbox(
          value: e.isDone(),
          onChanged: (newState) => setState(() {
            e.done = e.toggle();
          })
      ))
    ]));
  }

  Widget buildEditable() {
    return ListTile(title:
    Row( children: <Widget> [
      Container(
          width: 200,
          child: titleText
      ),
      Expanded(child: Container()),
      FlatButton(child: Text("Add"), onPressed: addElement,)
    ]));
  }

  @override
  Widget build(BuildContext context) {
    if(e.editing == true){
      return buildEditable();
    } else {
      return buildNormal();
    }
  }
}