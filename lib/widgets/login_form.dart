import 'package:cinnamon_app/screens/home_screen.dart';
import 'package:cinnamon_app/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:cinnamon_app/helpers/constants.dart';

class LoginForm extends StatefulWidget {
  @override
  State createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Enter email",
                  labelStyle: TextStyle(color: kPrimaryColor),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor))),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter email';
                }
                bool validEmail = Validator().validateEmail(value);
                if (!validEmail) {
                  return "Email is invalid!";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Enter password",
                  labelStyle: TextStyle(color: kPrimaryColor),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor))),
              validator: (value) {
                String validPassword = Validator().validatePassword(value);
                if (validPassword != null) {
                  return validPassword;
                }
                return null;
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                } else {
                  setState(() {
                    _autovalidate = true;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: kPrimaryColor,
            )
          ],
        ));
  }
}
