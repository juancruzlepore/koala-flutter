import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer';

import '../Person.dart';
import 'Movie.dart';
import 'MovieWidget.dart';

enum SeenFilterType { ALL, SEEN, NOT_SEEN }

class MovieListWidget extends StatefulWidget {
  MovieListWidget({Key key}) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState(fetchMovies());
}

class _MovieListWidgetState extends State<MovieListWidget> {
  Future<List<Movie>> moviesFuture;
  List<Movie> movies = [];
  List<Movie> showingMovies;
  Person user = Person.Anne;
  SeenFilterType seenFilter = SeenFilterType.ALL;

  _MovieListWidgetState(this.moviesFuture);

  void updateShowingMovies() {
    this.showingMovies = movies.where((m) => shouldShowMovie(m)).toList();
  }

  Future<Movie> showAddMovieDialog() {
    TextEditingController newMovieTextEditingCtrl = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Add movie'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: newMovieTextEditingCtrl),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GestureDetector(
                        onTap: () {
                          log('pressed avatar');
                          setState(() {
                            this.user =
                                user == Person.Anne ? Person.Juan : Person.Anne;
                          });
                        },
                        child: this.user.getAvatar(12))),
              ]),
              actions: [
                FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(Movie(newMovieTextEditingCtrl.text, user, false));
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ],
            );
          });
        });
  }

  String getSeenFilterText() {
    switch (seenFilter) {
      case SeenFilterType.ALL:
        return "showing all";
      case SeenFilterType.SEEN:
        return "showing only seen";
      case SeenFilterType.NOT_SEEN:
        return "showing only not seen";
    }
    return "";
  }

  Icon getSeenFilterIcon() {
    switch (seenFilter) {
      case SeenFilterType.ALL:
        return Icon(
          Icons.remove_red_eye,
          color: Colors.green[400],
        );
      case SeenFilterType.SEEN:
        return Icon(
          Icons.remove_red_eye,
          color: Colors.blue,
        );
      case SeenFilterType.NOT_SEEN:
        return Icon(
          Icons.remove_red_eye,
          color: Colors.grey[400],
        );
    }
    return null;
  }

  bool shouldShowMovie(Movie m) {
    switch (seenFilter) {
      case SeenFilterType.ALL:
        return true;
      case SeenFilterType.SEEN:
        return m.seen;
      case SeenFilterType.NOT_SEEN:
        return !m.seen;
    }
    return false;
  }

  Widget buildSeenFilter() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: FlatButton(
          child: Row(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: getSeenFilterIcon(),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(getSeenFilterText()))
          ]),
          color: Colors.orangeAccent[300],
          textColor: Colors.grey[400],
          onPressed: () {
            setState(() {
              switch (seenFilter) {
                case SeenFilterType.ALL:
                  seenFilter = SeenFilterType.NOT_SEEN;
                  break;
                case SeenFilterType.NOT_SEEN:
                  seenFilter = SeenFilterType.SEEN;
                  break;
                case SeenFilterType.SEEN:
                  seenFilter = SeenFilterType.ALL;
                  break;
              }
              updateShowingMovies();
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    updateShowingMovies();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Row(children: [
          Text("Movies"),
          Spacer(),
          buildSeenFilter(),
          GestureDetector(
              onTap: () {
                log('pressed avatar');
                setState(() {
                  this.user = user == Person.Anne ? Person.Juan : Person.Anne;
                });
              },
              child: this.user.getAvatar(12))
        ]),
      ),
      body: FutureBuilder<List<Movie>>(
        future: this.moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.movies = snapshot.data;
            return buildMoviesList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMovieDialog().then((newMovie) {
            setState(() {});
            if (newMovie != null) {
              setState(() {
                movies.add(newMovie);
                addMovie(newMovie).then((response) {
                  if (response.statusCode != HttpStatus.ok) {
                    log('Something went wrong adding a movie, response code: ' +
                        response.statusCode.toString());
                  }
                });
              });
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget buildMoviesList(List<Movie> movies) {
    updateShowingMovies();
    return Center(
        child: ListView(children: <Widget>[
      for (var movie in showingMovies) MovieWidget(movie)
    ]));
  }
}
