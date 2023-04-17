import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../providers/storage_service.dart';

class FarmCarasole extends StatefulWidget {
  String farmName;
  FarmCarasole(
      {required this.farmName,
      super.key});

  @override
  State<FarmCarasole> createState() => _FarmCarasoleState();
}

class _FarmCarasoleState extends State<FarmCarasole> {
  StorageService storage = StorageService();
  late List<Widget> imageSliders;
  bool loaded = false;
  @override
  void initState() {
    setup();
    super.initState();
  }

  Future<void> setup() async {
    List<String> imgList = await storage.getCaresoleDownloadURLs(farmName: widget.farmName);
    imageSliders = imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    item,
                    // height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ))
        .toList();
    loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: loaded 
          ? CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(autoPlay: true),
            )
          : const CircularProgressIndicator()
        ),
      ],
    );
  }
}
