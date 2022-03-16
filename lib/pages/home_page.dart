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
  void initState(){
    super.initState();
    httpClient = Client();
    ethClient = Web3Client("https://ropsten.infura.io/v3/0e9b6174a9204bb78853372424d0e113", httpClient);
    details();
  }

  details() async{
    dynamic data = await getUserDetails();
    data != null ?
    setState(() {
      var privAddress = data['privateKey'];
      var publicAddress = data['publicKey'];
      var temp = EthPrivateKey.fromHex(privAddress);
      credentials = temp.address;

      created = data['wallet created'];
      balance = getBalance(credentials);
    }):
    print('data is null');
  }

  Future<DeployedContract> loadContract() async{
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    String contractAddress = '0x26c5F8Ea7667b3648DFd8d336a451026c864c778';
    final contract = DeployedContract(ContractAbi.fromJson(abi, "SPC"), EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(EthereumAddress credentialAddress) async{
    List<dynamic> result = await query('balanceOf',[credentialAddress]);
    var data = result[0];
    setState(() {
      balance = data;
    });
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit('transfer', [targetAddress, bigAmount]);
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async{
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    EthPrivateKey key = EthPrivateKey.fromHex(privAddress);
    Transaction transaction = await Transaction.callContract(contract: contract, function: ethFunction, parameters: args, maxGas: 100000);
    print(transaction.nonce);
    final result = await ethClient.sendTransaction(key, transaction, chainId:4);
    return result;
  }



  
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
              margin: const EdgeInsets.all(20),
              child: Text(
              u_name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold
                ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.center,
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: const Text (
              "Balance",
              style: TextStyle(
                fontSize: 70,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.center,
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Text(
              balance == null?
                  "0 SPC":
                  "${balance}",
              style: const TextStyle(
                fontSize: 50,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async{
                var response = await sendCoin();
                print (response);
              },
              child: const Text('send money'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
              ),
            ),
          ),



          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                credentials !=null?
                    getBalance(credentials):
                    print("credentials null");
              },
              child: const Text('refresh page'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top:30, right: 30),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateWallet()));
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
