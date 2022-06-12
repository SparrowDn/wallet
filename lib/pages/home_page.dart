// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
//import 'package:syncfusion_flutter_sliders/sliders.dart';
//import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallet/wallet/userdetails.dart';
import 'package:wallet/pages/createwallet.dart';
//import 'package:wallet/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? Key, required this.title}): super(key: Key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Client httpClient;
  late Web3Client ethClient;
  String privAddress = '';
  EthereumAddress targetAddress = EthereumAddress.fromHex("0x26c5F8Ea7667b3648DFd8d336a451026c864c778");
  bool? created;
  var balance;
  var credentials;
  int myAmount = 5;
  var pro_pic;
  var u_name;
  // final myAdress = '0x26c5F8Ea7667b3648DFd8d336a451026c864c778';
  
  
  @override

  
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if(user?.photoURL == null) {pro_pic = 'abij/images/googlelogo.png';} else {pro_pic = user!.photoURL;}
    if(user?.displayName == null) {u_name = "User Name";} else {u_name = user!.displayName;}
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.blue,
            height: 150,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(pro_pic),
                  scale: 0.1
                )
              )
            ),),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
              '${u_name} 의 자기소개 페이지',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
                ),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.center,
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Text(
              "My Links",
              style: const TextStyle(
                fontSize: 30,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: _launchURL,
              icon: FaIcon(FontAwesomeIcons.youtube),
              label: Text('Youtube Channel'),
              //child: const Text('Youtube Channel'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: _launchURL2,
              icon: FaIcon(FontAwesomeIcons.facebookSquare),
              label: Text('Facebook Page'),
              //child: const Text('Facebook Channel'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: _launchURL3,
              icon: FaIcon(FontAwesomeIcons.instagramSquare),
              label: Text('Instagram Page'),
              //child: const Text('Facebook Channel'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purpleAccent)
              ),
            ),
          ),



          Container(
            margin: const EdgeInsets.only(top:30, right: 30),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: (){
                _launchURL4();
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL() async{
    const url = 'https://www.youtube.com/channel/UC2OWFEtrrJVMCS3EUH5kRoQ';
  launch(url);
  }

  _launchURL2() async{
    const url = 'https://www.facebook.com/profile.php?id=100003641890222';
    launch(url);
  }
  _launchURL3() async{
    const url = 'https://www.instagram.com/sparrowdn/';
    launch(url);
  }
  _launchURL4() async {
    const url = 'https://www.warcraftlogs.com/character/kr/%EC%95%84%EC%A6%88%EC%83%A4%EB%9D%BC/%ec%8a%a4%ed%8c%a8%eb%a1%9c%ec%82%ac%ec%a0%9c';
    launch(url);
  }
}
