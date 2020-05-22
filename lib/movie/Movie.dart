import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:developer';

//import "package:json_object/json_object.dart";
import 'package:http/http.dart' as http;
import 'package:koala/Person.dart';

class Movie {
  String title;
  Person creator;
  bool seen;

  Movie(this.title, this.creator, this.seen);

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      json['name'],
      Person.fromName(json['addedBy']),
      json['seen'],
    );
  }
}

Future<List<Movie>> fetchMovies() async {
  final response =
      await http.get('https://agile-hamlet-28702.herokuapp.com/movies/all');
  if (response.statusCode == 200) {
    Map<String, dynamic> decoded = (JSON.jsonDecode(JSON.jsonDecode(response.body).toString()) as Map<String, dynamic>);
    List<dynamic> decodedList = decoded["movies"];
    List<Movie> moviesList = List<Map<String, dynamic>>.from(decodedList)
        .map((Map<String, dynamic> model) => Movie.fromJson(model))
        .toList();
    return moviesList;
  } else {
    log('error');
    throw Exception('Failed to load movies');
  }
}

Future<http.Response> addMovie(Movie movie) {
  return http.post(
    'https://agile-hamlet-28702.herokuapp.com/movies/add',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.jsonEncode(<String, dynamic>{
      'name': movie.title,
      'addedBy': movie.creator.name,
      'seen': false
    }),
  );
}
