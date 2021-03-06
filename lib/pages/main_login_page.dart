import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/auth/GoogleSigninProvider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height/1.6,
            margin: const EdgeInsets.all(30),
            child: Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  child: Image.asset('assets/images/googlelogo.png'),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Container(
            child: SignInButton(
              Buttons.Google,
              text: "sign-up with google",
              onPressed: (){
                final provider = Provider.of<GoogleSignInProvider>(context, listen:false);
                provider.googleLogin();
              }
            ),
          ),
          Container(
            child: SignInButton(
              Buttons.Facebook,
              text: "sign-up with Facebook",
              onPressed: (){},
            ),
          )
        ],
      ),
    );
  }
}
