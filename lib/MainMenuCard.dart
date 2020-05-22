import 'package:flutter/material.dart';

class MainMenuCard extends StatelessWidget {

  final StatefulWidget Function (BuildContext) next;
  final String title;

  MainMenuCard(this.next, this.title);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                this.title,
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                    fontFamily: 'Montserrat'),
              ),
            ),
            alignment: Alignment.topLeft,
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text('Go'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: this.next));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}