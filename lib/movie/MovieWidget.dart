import 'dart:ui';

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

  Widget getSeenWidget() {
    return IconButton(
        icon: Icon(Icons.remove_red_eye,
            color: movie.seen ? Colors.blue : Colors.grey[300]),
        onPressed: () {
          setState(() {
            movie.seen = !movie.seen;
          });
          addMovie(this.movie);
        },
        splashRadius: 3.0,
    );
  }

  Widget getMovieRatingWidget() {
    if (movie.rating == null || movie.rating < 0) {
      return FutureBuilder<IMDBResult>(
        future: getIMDBResult(movie.title),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            movie.rating = snapshot.data.rating;
            addMovie(movie);
            return MovieRatingWidget(snapshot.data.rating);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Padding(
              padding: EdgeInsets.only(left: 4.0, right: 4.0),
              child: SizedBox(
                  width: 10,
                  height: 10,
                  child: Center(child: CircularProgressIndicator())));
        },
      );
    } else {
      return MovieRatingWidget(movie.rating);
    }
  }

  Widget buildNormal() {
    return Card(
        child: ListTile(
            title: Text('${movie.title}',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w400)),
            subtitle: Row(children: <Widget>[
              SizedBox(
                  width: 40,
                  child: movie.creator.getAvatar(12, borderWidth: 2)),
              SizedBox(width: 40, child: getSeenWidget()),
              Spacer(),
              SizedBox(width: 60, child: getMovieRatingWidget()),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return buildNormal();
  }
}

class MovieRatingWidget extends StatelessWidget {
  final double rating;

  MovieRatingWidget(this.rating);

  @override
  Widget build(BuildContext context) {
    if (rating != null && rating >= 0) {
      return Padding(
          padding: EdgeInsets.only(left: 4.0, right: 4.0),
          child: Row(children: [
            Text(this.rating.toString()),
            Icon(
              Icons.star,
              color: Colors.yellow,
            ),
          ]));
    }
    return Text("");
  }
}
