import 'package:cinnamon_app/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    print("Database created");
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "movies.db"), onCreate: (db, version) async {
      await db.execute("CREATE TABLE movies (id INTEGER PRIMARY KEY ,title TEXT,description TEXT,poster TEXT, isFavorited BOOLEAN)");
    }, version: 1);
  }

  Future<dynamic> newMovies(List<Movie> newMovies) async {
    final db = await database;
    Batch batch = db.batch();
    newMovies.forEach((element) {
      batch.insert("movies", element.toMap());
    });
    batch.commit();
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    var res = await db.query("movies");
    if (res.length == 0) {
      return new List<Movie>();
    } else {
      List<Movie> favoritedMovies = res.isNotEmpty ? res.map((c) => Movie.fromMap(c)).toList() : [];
      return favoritedMovies;
    }
  }

  Future<dynamic> deleteAll() async {
    final db = await database;
    db.rawDelete("DELETE FROM movies");
  }
}
