import 'dart:ui';

import 'package:flutter/material.dart';

import 'Movie.dart';

class MovieWidget extends StatefulWidget {
  final Movie movie;

  MovieWidget(this.movie): super(key: Key(movie.title));

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

  Widget getMovieGenresWidget() {
    if (movie.genre == null || movie.genre.isEmpty) {
      return FutureBuilder<IMDBResult>(
        future: getIMDBResult(movie.title),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            movie.setGenre(snapshot.data.genre);
            addMovie(movie);
            return MovieGenresWidget(movie.genre);
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
      return MovieGenresWidget(movie.genre);
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
              SizedBox(width: 100, child: getMovieGenresWidget()),
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

class MovieGenresWidget extends StatelessWidget {
  final List<String> genre;

  MovieGenresWidget(this.genre);

  final Map<String, String> genreToEmoji = {
    "Action": "👮‍",
    "Adventure": "🧗‍♀️‍",
    "Animation": "👾",
    "Biography": "📒‍",
    "Comedy": "😂",
    "Drama": "🎭",
    "Family": "👨‍👩‍👦",
    "Fantasy": "🧚‍️",
    "Romance": "❤️",
    "Sci-Fi": "🦾‍",
  };

  @override
  Widget build(BuildContext context) {
    if (genre != null && genre.isNotEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(children: [for (String g in genre)
            Text(genreToEmoji.containsKey(g) ? genreToEmoji[g] : g),
          ]));
    }
    return Text("");
  }
}
