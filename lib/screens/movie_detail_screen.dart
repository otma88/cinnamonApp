import 'package:cinnamon_app/helpers/constants.dart';
import 'package:cinnamon_app/model/movie_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cinnamon_app/model/movie.dart';
import 'package:cinnamon_app/network/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinnamon_app/model/genre.dart';

Future<MovieDetail> _fetchMovieDetails(int movieId) async {
  var response = await http.get(Network().baseUrl + movieId.toString() + "?api_key=" + Network().api_key);
  if (response.statusCode == 200) {
    return MovieDetail.fromJson(json.decode(response.body));
  } else {
    return null;
  }
}

class MovieDetailScreen extends StatefulWidget {
  int movieId;
  MovieDetailScreen({this.movieId});

  @override
  State createState() {
    return MovieScreenState();
  }
}

class MovieScreenState extends State<MovieDetailScreen> {
  Future<MovieDetail> _movieDetails;

  @override
  void initState() {
    super.initState();
    _movieDetails = _fetchMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MOVIE DETAILS",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        child: FutureBuilder<MovieDetail>(
            future: _movieDetails,
            //ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  {
                    break;
                  }
                case ConnectionState.active:
                  {
                    break;
                  }
                case ConnectionState.waiting:
                  {
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: kSecondaryColor,
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      ),
                    );
                  }
                case ConnectionState.done:
                  {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                                      image: NetworkImage(Network().base_url_poster + snapshot.data.backdrop_path),
                                      fit: BoxFit.cover)),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Text(
                                        snapshot.data.title,
                                        style: TextStyle(fontSize: 30.0, color: Colors.white),
                                      ),
                                      alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text(
                                          snapshot.data.tagline,
                                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                                        ),
                                      )),
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) => SizedBox(
                                        width: 20.0,
                                      ),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.genres[index].name,
                                              style: TextStyle(fontSize: 15.0, color: Colors.white),
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: snapshot.data.genres.length,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Image.network(
                                            Network().base_url_poster + snapshot.data.poster,
                                            height: 150.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Container(
                                        child: Text(
                                          "Popularity: " + snapshot.data.popularity.toString(),
                                          style: TextStyle(fontSize: 30.0, color: kSecondaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data.description),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      Center(
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
            }),
      ),
    );
  }
}
