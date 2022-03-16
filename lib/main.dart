import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wallet/auth/GoogleSigninProvider.dart';
import 'package:wallet/pages/login_page.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      title: 'flutter demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Raleway'
      ),

      home: FutureBuilder(
        future: _fbapp,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            print('you have an error! ${snapshot.error.toString()}');
            return const Text('something went wrong!');
          }
          else if (snapshot.hasData) {
            return AnimatedSplashScreen(splash: 'assets/images/googlelogo.png',
            pageTransitionType: PageTransitionType.bottomToTop,
            duration: 3000,
            nextScreen: Login(),);
          }
          else {
            return const Center(
            child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),);
  }
}
