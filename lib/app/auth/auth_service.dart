import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //String email, password;
  //Handle Auth
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LoginPage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  //SignOut
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  Future<bool> signIn(email, password) async {
    var signedIn = false;
    //Firebase await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      if (user.user != null) {
        print('Signed in');
        signedIn = true;
      } else {
        print('invalid');
        signedIn = false;
      }
    });
    return signedIn;
  }
}
