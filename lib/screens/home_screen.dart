import 'package:cinnamon_app/database/database.dart';
import 'package:cinnamon_app/network/api.dart';
import 'package:cinnamon_app/screens/movie_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cinnamon_app/helpers/constants.dart';
import 'package:cinnamon_app/model/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Movie>> _fetchMovies() async {
  var response = await http.get(Network().baseUrl + "top_rated?api_key=" + Network().api_key + "&page=1");
  if (response.statusCode == 200) {
    return compute(parseMovies, response.body);
  } else {
    return null;
  }
}

List<Movie> parseMovies(String responseBody) {
  final parsed = jsonDecode(responseBody);
  Map<String, dynamic> pas = parsed;
  return pas['results'].map<Movie>((json) => Movie.fromJson(json)).toList();
}

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  Future<List<Movie>> _movies;
  List<Movie> _favoritedMovies = new List<Movie>();

  getFavoritedMovies() async {
    List<Movie> movieList = await DBProvider.db.getAllMovies();
    setState(() {
      _favoritedMovies = movieList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _movies = _fetchMovies();
    //getFavoritedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HOME",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
//              DBProvider.db.deleteAll();
//              DBProvider.db.newMovies(_favoritedMovies);
              Navigator.pop(context);
            }),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Material(
              color: kSecondaryColor,
              child: Container(
                height: 70.0,
                child: TabBar(
                  labelStyle: TextStyle(fontSize: 20.0),
                  tabs: [
                    Tab(
                      text: "MOVIES",
                    ),
                    Tab(
                      text: "FAVORITES",
                    )
                  ],
                  indicatorColor: kPrimaryColor,
                ),
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FutureBuilder<List<Movie>>(
                  future: _movies,
                  //ignore: missing_return
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        {
                          break;
                        }
                      case ConnectionState.waiting:
                        {
                          return Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              backgroundColor: kSecondaryColor,
                              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        }
                      case ConnectionState.active:
                        {
                          break;
                        }
                      case ConnectionState.done:
                        {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10.0,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (!snapshot.data[index].isFavorited) {
                                        _favoritedMovies.add(snapshot.data[index]);
                                      } else {
                                        _favoritedMovies.remove(snapshot.data[index]);
                                      }
                                      snapshot.data[index].isFavorited = !snapshot.data[index].isFavorited;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(color: kPrimaryColor, border: Border.all(color: kSecondaryColor), borderRadius: BorderRadius.circular(10.0)),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                                              child: Image.network(
                                                Network().base_url_poster + snapshot.data[index].poster,
                                                height: 60.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      snapshot.data[index].title,
                                                      style: TextStyle(fontSize: 20.0, color: kSecondaryColor),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      snapshot.data[index].description.length > 20
                                                          ? snapshot.data[index].description.substring(0, 20) + "..."
                                                          : snapshot.data[index].description,
                                                      style: TextStyle(fontSize: 15.0, color: kSecondaryColor),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                              child: snapshot.data[index].isFavorited
                                                  ? Icon(Icons.star, color: kSecondaryColor, size: 40.0)
                                                  : Icon(Icons.star_border, color: kSecondaryColor, size: 40.0))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data.length,
                            );
                          } else {
                            return Center(
                              child: Container(
                                child: Text(
                                  "Failed to fetch data",
                                  style: TextStyle(fontSize: 25.0, color: kSecondaryColor),
                                ),
                              ),
                            );
                          }
                        }
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _favoritedMovies.length != 0
                    ? ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: _favoritedMovies[index].id)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(color: kPrimaryColor, border: Border.all(color: kSecondaryColor), borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                                        child: Image.network(
                                          Network().base_url_poster + _favoritedMovies[index].poster,
                                          height: 60.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                _favoritedMovies[index].title,
                                                style: TextStyle(fontSize: 20.0, color: kSecondaryColor),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                _favoritedMovies[index].description.length > 20
                                                    ? _favoritedMovies[index].description.substring(0, 20) + "..."
                                                    : _favoritedMovies[index].description,
                                                style: TextStyle(fontSize: 15.0, color: kSecondaryColor),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        child: Icon(
                                      Icons.arrow_forward,
                                      color: kSecondaryColor,
                                      size: 40.0,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _favoritedMovies.length,
                      )
                    : Center(
                        child: Container(
                          child: Text(
                            "Add favorited movies",
                            style: TextStyle(fontSize: 25.0, color: kSecondaryColor),
                          ),
                        ),
                      ),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
