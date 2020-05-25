import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:developer';

//import "package:json_object/json_object.dart";
import 'package:http/http.dart' as http;
import 'package:koala/Person.dart';

abstract class IMDBAPI {
  static const String key = "847a4c0c";
  static const String keyParamName = "apikey";
  static const String domain = "www.omdbapi.com";
  static const String path = "/";
}

class IMDBResult {
  String title;
  double rating;
  String genre;
  bool found;

  static final IMDBResult error = IMDBResult(found: false);

  IMDBResult({this.title, this.rating, this.genre, this.found});
}

class Movie {
  String title;
  Person creator;
  bool seen;
  double rating;
  List<String> genre;

  Movie(this.title, this.creator, this.seen, [this.rating = -1, this.genre]);

  void setGenre(String genre){
    this.genre = getGenreList(genre);
  }

  static List<String> getGenreList(String genreString) {
    if (genreString == null || genreString.isEmpty) return [];
    return genreString.split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        json['name'],
        Person.fromName(json['addedBy']),
        json['seen'],
        json['rating'],
        getGenreList((json['genre'] ?? "") as String)
    );
  }
}

// &t=Ice age
Future<List<Movie>> fetchMovies() async {
  final response =
      await http.get('https://agile-hamlet-28702.herokuapp.com/movies/all');
  if (response.statusCode == 200) {
    Map<String, dynamic> decoded =
        (JSON.jsonDecode(JSON.jsonDecode(response.body).toString())
            as Map<String, dynamic>);
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
      'seen': movie.seen,
      'rating': movie.rating,
      'genre': movie.genre?.join(',')
    }),
  );
}

Future<IMDBResult> getIMDBResult(String title) {
  var queryParameters = {
    IMDBAPI.keyParamName: IMDBAPI.key,
    't': title,
  };

  Uri uri = Uri.https(IMDBAPI.domain, IMDBAPI.path, queryParameters);
  return http.get(uri).then((json) {
    Map<String, dynamic> obj = JSON.jsonDecode(json.body);
    if (obj["Error"] != null || double.tryParse(obj["imdbRating"]) == null) {
      return IMDBResult.error;
    }
    return IMDBResult(
        title: obj["Title"],
        rating: double.parse(obj["imdbRating"]),
        genre: obj["Genre"]);
  });
}
