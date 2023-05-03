// import 'dart:html';

import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/earlySignIn/emailInput.dart';
import '../widgets/common/title.dart';

class EarlySignUpScreen extends StatelessWidget {
  static const routeName = '/earlysignup';
  const EarlySignUpScreen({Key? key}) : super(key: key);

  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController;
    double width = MediaQuery.of(context).size.width;
    var image = Image.asset('lib/assets/images/7.png');
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
          // title: const TitleWWidget(),
          centerTitle: true,
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              width <= 750
                  ? Column(
                      // image
                      children: [const Text1(), image],
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: width / 3,
                          child: const Text1(),
                        ),
                        Column(
                          // image
                          children: [
                            SizedBox(width: (width / 3) * 2, child: image)
                          ],
                        )
                      ],
                    ),
            ],
          ),
        )));
  }
}

class Text1 extends StatelessWidget {
  const Text1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // sign up
      children: [
        TitleWidget(
          size: 50,
        ),
        const Text(
          '''From Farm 2 Connoisseur''',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            color: Color.fromRGBO(249, 94, 32, 1),
          ),
        ),
        const SizedBox(height: 10,),
        // RichText(
        //   text: const TextSpan(
        //     text: 'CARDANO NFT',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       color: Color.fromARGB(255, 1, 207, 183),
        //       fontSize: 20
        //       ),
        //     children: <TextSpan>[
        //       TextSpan(text: ' Backed Proof Of Origin', 
        //       style: TextStyle(
        //         color: Colors.white,
        //       fontSize: 20
        //       )),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 10,),
        const Text(
          '''CARDANO NFT''',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 1, 207, 183),
              fontSize: 20),
        ),
        const Text(
          '''Backed Proof Of Origin''',
          textAlign: TextAlign.center,
          style: TextStyle(
                color: Colors.white,
              fontSize: 20),
        ),
        const SizedBox(height: 10,),
        const Text(
          '''Coming Soon!''',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color:Color.fromRGBO(249, 94, 32, 1),),
        ),
        const SizedBox(height: 10,),
        const Text(
          '''Sign Up To Stay Notified.''',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color:Color.fromRGBO(249, 94, 32, 1)),
        ),
        const EmailInputField(),
        const SizedBox(height: 10,),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '''If you choose to provide us with your email address, we will use it only to send updates on the CoffeeDAO NFT project. If you choose to unsubscribe write to contact@nft-dao.org.''',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color:Colors.white),
          ),
        ),
      ],
    );
  }
}
