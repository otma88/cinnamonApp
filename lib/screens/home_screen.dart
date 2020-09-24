import 'package:cinnamon_app/screens/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:cinnamon_app/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HOME",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: kPrimaryColor,
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
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: MovieCard(),
                    );
                  },
                  itemCount: 6,
                ),
              ),
              Text("FAVORITES")
            ]))
          ],
        ),
      ),
    );
  }
}
