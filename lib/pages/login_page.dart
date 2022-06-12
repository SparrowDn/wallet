import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallet/pages/main_login_page.dart';
import 'package:wallet/pages/home_page.dart';


class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else if (snapshot.hasData) {
            return MyHomePage(title: "자기소개 페이지");
          } else if (snapshot.hasError) {
            return const Center(child: Text('something went wrong!'),);
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
