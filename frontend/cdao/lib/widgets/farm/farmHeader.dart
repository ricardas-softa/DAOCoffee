import 'package:flutter/material.dart';

import '../../providers/storage_service.dart';

class FarmHeader extends StatefulWidget {
  String farmName;
  FarmHeader(
      {required this.farmName,
      super.key});

  @override
  State<FarmHeader> createState() => _FarmHeaderState();
}

class _FarmHeaderState extends State<FarmHeader> {
  StorageService storage = StorageService();
  late String imgUrl;
  bool loaded = false;
  @override
  void initState() {
    setup();
    super.initState();
  }

  Future<void> setup() async {
    imgUrl = await storage.getHeaderDownloadURLs(farmName: widget.farmName);
    loaded = true;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    final Gradient gradient = LinearGradient(colors: [
      // const Color.fromARGB(255, 1, 207, 183),
      Colors.orange,
      Colors.red.shade900,
    ]);
    const Gradient gradient2 = LinearGradient(colors: [
      Color.fromARGB(255, 1, 207, 183),
      Colors.orange,
      // Colors.red.shade900,
    ]);
    return ! loaded 
      ? const CircularProgressIndicator()
      : Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.network(imgUrl,
              // height: 250,
              width: mWidth,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: mWidth,
            child: Center(
              child: Column(
                children: [
                  // ShaderMask(
                  //   blendMode: BlendMode.srcIn,
                  //   shaderCallback: (bounds) => gradient2.createShader(
                  //     Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  //   ),
                  //   child: Text(
                  //     '''Village Of''',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         fontFamily: 'Alonira', 
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.orange, 
                  //         fontSize: mWidth < 753 ? 20 : mWidth < 1225 && mWidth >= 753 ? 20 : 40), //1225
                  //   ),
                  // ),
                  // SizedBox(height: mWidth < 753 ? mWidth/3 - 25 : mWidth < 1225 && mWidth >= 753 ? mWidth/3 + 20 : mWidth/7 * 2 + 75,),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => gradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      '''Los Hornos''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Alonira', 
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, 
                          fontSize: mWidth < 753 ? 40 : mWidth < 1225 && mWidth >= 753 ? 60 : 100),
                    ),
                  ),
                  SizedBox(height: mWidth/4*2,),
                  Text('''Comayagua, Honduras''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mWidth < 753 ? 15 : mWidth < 1225 && mWidth >= 753 ? 30 : 40,
                        color: Colors.orange
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }
}