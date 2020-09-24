import 'package:flutter/material.dart';
import 'package:cinnamon_app/constants.dart';

class MovieCard extends StatefulWidget {
  @override
  State createState() {
    return MovieCardState();
  }
}

class MovieCardState extends State<MovieCard> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kPrimaryColor, border: Border.all(color: kSecondaryColor), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Image.network(
                "https://picsum.photos/250?image=9",
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
                      "Movie title",
                      style: TextStyle(fontSize: 20.0, color: kSecondaryColor),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Short description",
                      style: TextStyle(fontSize: 15.0, color: kSecondaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: IconButton(
              icon: _isFavorited ? Icon(Icons.star) : Icon(Icons.star_border),
              onPressed: () {
                setState(() {
                  _isFavorited = !_isFavorited;
                });
              },
              iconSize: 40.0,
              color: kSecondaryColor,
            ),
          )
        ],
      ),
    );
  }
}
