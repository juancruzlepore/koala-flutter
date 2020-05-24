import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer';

import '../Person.dart';
import 'Movie.dart';
import 'MovieWidget.dart';

class MovieListWidget extends StatefulWidget {
  MovieListWidget({Key key}) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState(fetchMovies());
}

class _MovieListWidgetState extends State<MovieListWidget> {
  Future<List<Movie>> moviesFuture;
  List<Movie> movies;
  Person user = Person.Anne;

  _MovieListWidgetState(this.moviesFuture);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Row(children: [
          Text("Movies"),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    log('pressed avatar');
                    setState(() {
                      this.user =
                          user == Person.Anne ? Person.Juan : Person.Anne;
                    });
                  },
                  child: this.user.getAvatar(12)))
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
    return Center(
        child: Column(
            children: <Widget>[for (var movie in movies) MovieWidget(movie)]));
  }
}
