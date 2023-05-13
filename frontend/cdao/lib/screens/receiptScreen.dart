import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes/route_const.dart';
import '../widgets/common/title.dart';

class ReceiptScreen extends StatefulWidget {
  String data;
  ReceiptScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Map param;
  bool loading = true;
  String url = 'https://preprod.cardanoscan.io/transaction/';

  Future<void> inni() async {
    param = await json.decode(widget.data);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    inni();
  }

  Future<void> launchInBrowser() async {
    if (!await launchUrl(
      Uri.parse('''$url${param['hash']}'''),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url${param['hash']}';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Padding(
            padding: EdgeInsets.all(width < 753 ? 20 : 40.0),
            child: TitleWidget(size: width < 753 ? 25 : 50),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      const Text('Thank You For Your Purchase!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.orange
                      ),),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.network(param['nftUrl']),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Your Purchases Confirmation Hash:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange
                      ),),
                      Text(param['hash'],
                      textAlign: TextAlign.center,),
                      const SizedBox(height: 20,),
                      const Text(
                          'You can view your purchase on the Cardano blockchain explorer CardanoScan.io:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange
                      ),),
                      TextButton(
                        onPressed: () => setState(() {
                          launchInBrowser();
                        }), 
                        child: Text('''$url${param['hash']}''',
                          textAlign: TextAlign.center,
                          style: const TextStyle( 
                            color: Colors.blue,
                          ),
                        )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('SHIPPING',
                      style: TextStyle(
                        color: Colors.orange
                      ),),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          '''Your coffee will be shipped by Aug 10, 2023. Be on the look out for update emails from info@coffeedao.org. Feel free to reach out to us at the same email if you have any questions concerning your order.''',
                      textAlign: TextAlign.center,),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                          onPressed: () {
                            context.goNamed(CDAOConstants.losHornosRoute);
                          },
                          child: const Text(
                            '''More NFT's & Coffee?''',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ))
                    ],
                  ),
          ),
        )));
  }
}
