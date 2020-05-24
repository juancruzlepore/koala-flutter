import 'package:flutter/material.dart';

import 'custom_icons_icons.dart';

class MainMenuCard extends StatelessWidget {
  final StatefulWidget Function(BuildContext) next;
  final String title;
  final Color color;
  final IconData icon;

  MainMenuCard(this.next, this.title, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Padding(padding: EdgeInsets.all(10.0), child: Icon(this.icon)),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                this.title,
                style: TextStyle(
                    color: this.color,
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
                child:
                    const Text('Go', style: TextStyle(color: Colors.black45)),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: this.next));
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
