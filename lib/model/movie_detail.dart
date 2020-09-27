import 'package:cinnamon_app/model/genre.dart';

class MovieDetail {
  final int id;
  final String title;
  final String description;
  final String poster;
  final String backdrop_path;
  final List<Genre> genres;
  final String tagline;
  final double popularity;
  final String year;

  MovieDetail({this.id, this.title, this.description, this.poster, this.genres, this.tagline, this.popularity, this.year, this.backdrop_path});

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    var list = json['genres'] as List;
    List<Genre> genreList = list.map((i) => Genre.fromJson(i)).toList();

    return MovieDetail(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['overview'] as String,
        poster: json['poster_path'] as String,
        backdrop_path: json['backdrop_path'] as String,
        genres: genreList,
        tagline: json['tagline'] as String,
        popularity: json['popularity'] as double,
        year: json['year'] as String);
  }
}
