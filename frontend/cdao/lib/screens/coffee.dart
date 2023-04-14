import 'package:flutter/material.dart';
import 'dart:js' as js;

import '../services/lucid_service.dart';
import '../widgets/common/title.dart';
import '../widgets/farm/farmHeader.dart';

class CoffeeScreen extends StatelessWidget {
  const CoffeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double boxH = 20;
    final Gradient gradient = LinearGradient(colors: [
      // const Color.fromARGB(255, 1, 207, 183),
      Colors.orange,
      Colors.red.shade900,
    ]);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: mWidth < 753 ? 65 : 130,
          backgroundColor: Colors.black,
          title: Padding(
            padding: EdgeInsets.all(mWidth < 753 ? 20 : 40.0),
            child: TitleWidget(size: mWidth < 753 ? 25 : 50),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  FarmHeader(),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: const [
                  //     FarmHeader(),
                  //   ]),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // description of the village
                      const Text(
                          ''' Description of the village/farm: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''',
                          textAlign: TextAlign.center,),
                       SizedBox(
                        height: boxH,
                      ),
                      // description of the projecct
                      const Text(
                          ''' Description of the project: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''',
                          textAlign: TextAlign.center,),
                       SizedBox(
                        height: boxH,
                      ),
                      // description of the coffee
                      const Text(
                          ''' Description of the coffee: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''',
                          textAlign: TextAlign.center,),
                       SizedBox(
                        height: boxH,
                      ),
                      // coffee bag image
                      Image.asset(
                        'lib/assets/images/Coffee-Packaging.jpg',
                        width: mWidth / 5,
                      ),
                       SizedBox(
                        height: boxH,
                      ),
                      // short description of the purchasing process
                      const Text(
                          ''' Description of the purchasing process: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''',
                          textAlign: TextAlign.center,),
                       SizedBox(
                        height: boxH,
                      ),
                      // shipping info form
                      // walllet connector button
                      ElevatedButton(
                          onPressed: () async {
                            await LucidService.connectNamiWallet();
                          },
                          child: const Text('Purchase')),
                      // purchase status field
                      // error message field
                    ]),
              ),
            ],
          ),
        ));
  }
}
