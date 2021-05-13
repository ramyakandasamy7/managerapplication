import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;

  final formKey = new GlobalKey<FormState>();

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                height: 500.0,
                width: 800.0,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              child: Image.asset(
                                'basket.jpg',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 20.0,
                                    bottom: 5.0),
                                child: Container(
                                  height: 50.0,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    decoration:
                                        InputDecoration(hintText: 'Email'),
                                    validator: (value) => value.isEmpty
                                        ? 'Email is required'
                                        : validateEmail(value.trim()),
                                    onChanged: (value) {
                                      this.email = value;
                                    },
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 20.0,
                                    bottom: 5.0),
                                child: Container(
                                  height: 50.0,
                                  child: TextFormField(
                                    obscureText: true,
                                    style: TextStyle(color: Colors.black),
                                    decoration:
                                        InputDecoration(hintText: 'Password'),
                                    validator: (value) => value.isEmpty
                                        ? 'Password is required'
                                        : null,
                                    onChanged: (value) {
                                      this.password = value;
                                    },
                                  ),
                                )),
                            InkWell(
                                onTap: () async {
                                  if (checkFields()) {
                                    bool results = await AuthService()
                                        .signIn(email, password);
                                    print(results);
                                    if (results == true) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute<void>(
                                            builder: (_) => HomePage()),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                    height: 40.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xff2A3F54),
                                    ),
                                    child: Center(
                                        child: Text('Sign in',
                                            style: TextStyle(
                                                color: Color(0xffBAB8B8))))))
                          ],
                        ))
                  ],
                ))));
  }
}
