import 'package:cinnamon_app/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:cinnamon_app/helpers/constants.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "CinnamonApp",
                  style: TextStyle(fontSize: 30.0, color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: LoginForm(),
                )),
          ],
        ),
      ),
    );
  }
}
