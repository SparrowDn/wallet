import 'package:flutter/material.dart';
import 'package:wallet/pages/home_page.dart';
import 'package:wallet/wallet/userdetails.dart';
import 'package:wallet/wallet/wallet.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  int? selected;
  String? pubAddress;
  String? privAddress;
  String? username;

  @override
  void initState() {
    super.initState();
    details();
  }

  details() async {
    dynamic data = await getUserDetails();
    data != null?
    setState(() {
      privAddress = data['privateKey'];
      pubAddress = data['publicKey'];
      username = data['user_name'];
      bool created = data['wallet_created'];
      created == true ? selected = 1 : selected = 0;
    }):
    setState(() {
      selected = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('링크 추가하기'), actions: [
          IconButton(
            icon: const Icon(Icons.backspace),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]),
        body: Column(children: [
          selected == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text('add a wallet'),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          child: const Icon(Icons.add),
                          onPressed: () async {
                            setState(() {
                              selected = 1;
                            });
                            WalletAddress service = WalletAddress();
                            final mnemonic = service.generateMnemonic();
                            final privateKey =
                                await service.getPrivateKey(mnemonic);
                            final publicKey =
                                await service.getPublicKey(privateKey);
                            privAddress = privateKey;
                            pubAddress = publicKey.toString();
                            addUserDetails(privateKey, publicKey);
                          },
                        ))
                  ],
                )
              : Column(
                  children: [
                    Center(
                        child: Container(
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueAccent,
                          child: const Text(
                        'successfully initiated wallet!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )),
                    const Center(
                      child: Text(
                        'wallet private address :',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "{$privAddress}",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "do not reveal your private address to anyone!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Center(
                      child: const Text(
                        'wallet public address :',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "{$pubAddress}",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Divider(),
                    Center(
                      child: ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'myhomepage')),);}, child: Text('go back to main page', style: TextStyle(color: Colors.grey, fontSize: 18),))
                        ),
                  ],
                )
        ]));
  }
}
