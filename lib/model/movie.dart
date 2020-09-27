import 'package:cinnamon_app/model/genre.dart';

class Movie {
  final int id;
  final String title;
  final String description;
  final String poster;
  bool isFavorited;

  Movie({this.id, this.title, this.description, this.poster, this.isFavorited});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(id: json['id'] as int, title: json['title'] as String, description: json['overview'] as String, poster: json['poster_path'] as String, isFavorited: false);
  }

  factory Movie.fromMap(Map<String, dynamic> json) =>
      new Movie(id: json["id"], title: json["title"], description: json['description'], poster: json['poster'], isFavorited: json['isFavorited'] == 1 ? true : false);

  Map<String, dynamic> toMap() => {"id": id, "title": title, "description": description, "poster": poster, "isFavorited": isFavorited};
}
