import 'package:flutter/material.dart';

import 'Movie.dart';

class MovieWidget extends StatefulWidget {
  final Movie movie;

  MovieWidget(this.movie);

  @override
  State<StatefulWidget> createState() {
    return _MovieWidgetState(movie);
  }
}

class _MovieWidgetState extends State<MovieWidget> {
  Movie movie;

  _MovieWidgetState(Movie movie) {
    this.movie = movie;
  }

  Widget buildNormal() {
    return ListTile(
        title: Text('${movie.title}',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w400)),
        subtitle: Row(children: <Widget>[
          Expanded(child: Text((movie.seen ? 'seen ✓✓' : ''),
              style: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.w300))),
          movie.creator.getAvatar(12, borderWidth: 2),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return buildNormal();
  }
}
