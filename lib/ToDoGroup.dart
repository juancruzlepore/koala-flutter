import 'package:flutter/material.dart';
import 'package:koala/ToDoElement.dart';

class ToDoGroup {
  String name;
  bool done;
  bool editing;
  bool expanded;

  List<ToDoElement> subElems = [];

  void setDefaults(String name) {
    this.name = name;
    this.done = false;
    this.subElems = [ToDoElement("subtask 1"), ToDoElement("subtask 2")];
    this.expanded = true;
  }

  ToDoGroup(String name) {
    setDefaults(name);
    this.editing = false;
  }

  ToDoGroup._editable() {
    setDefaults('');
    this.editing = true;
  }

  static ToDoGroup buildEditable() {
    return ToDoGroup._editable();
  }

  bool isDone() {
    return done;
  }

  bool toggle() {
    return done = !done;
  }

  bool isExpanded() {
    return expanded;
  }

  void toggleExpanded() {
    expanded = !expanded;
  }
}

class ToDoGroupWidget extends StatefulWidget {
  ToDoGroup e;

  ToDoGroupWidget(ToDoGroup element) {
    this.e = element;
  }

  @override
  State<StatefulWidget> createState() {
    return _ToDoGroupWidgetState(e);
  }
}

class _ToDoGroupWidgetState extends State<ToDoGroupWidget> {
  ToDoGroup e;
  TextField titleText;

  static final subtaskHeight = 60.0;

  _ToDoGroupWidgetState(ToDoGroup element) {
    this.e = element;
    titleText = TextField(
      decoration: InputDecoration(border: InputBorder.none, hintText: 'Title'),
      style: TextStyle(fontSize: 22),
      onChanged: updateTitle,
    );
  }

  void addElement() {
    this.setState(() {
      e.editing = false;
    });
  }

  void toggleExpanded() {
    this.setState(() {
      e.expanded = !e.expanded;
    });
  }

  void updateTitle(text) {
    e.name = text;
  }

  Widget buildNormal(header) {
    return Column(
      children: <Widget>[header, if (e.expanded) buildSubElems()],
    );
  }

  Widget buildHeader() {
    if (e.editing) {
      return buildEditableHeader();
    } else {
      return buildNormalHeader();
    }
  }

  Widget buildNormalHeader() {
    return ListTile(
        title: Row(children: <Widget>[
          Text('${e.name}', style: TextStyle(fontSize: 22)),
          Expanded(child: Container()),
          FlatButton.icon(
            color: Colors.transparent,
            icon: Icon(e.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
//        label: Text(e.expanded ? "Hide list" : "Show list"),
            label: Text(""),
            onPressed: toggleExpanded,
          ),
          Container(
              child: Checkbox(
                  value: e.isDone(),
                  onChanged: (newState) => setState(() {
                    e.done = e.toggle();
                  })))
        ]));
  }

  Widget buildEditableHeader() {
    return ListTile(
        title: Row(children: <Widget>[
          Container(width: 200, child: titleText),
          Expanded(child: Container()),
          FlatButton(
            child: Text("Add"),
            onPressed: addElement,
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var header;
    if (e.editing == true) {
      header = buildEditableHeader();
    } else {
      header = buildNormalHeader();
    }
    return buildNormal(header);
  }

  Widget buildSubElems() {
    return Row(
      children: <Widget>[
        new ClipRRect(
          borderRadius: new BorderRadius.circular(15.0),
          child: SizedBox(
            width: 5,
            height: e.subElems.length * subtaskHeight,
            child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.green)),
          ),
        ),
        Expanded(
            child: Column(
              children: <Widget>[
                for (var subElem in e.subElems)
                  Container(height: subtaskHeight, child: ToDoElementWidget(subElem))
              ],
            ))
      ],
    );
  }
}
