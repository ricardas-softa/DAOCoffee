import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/nftsModel.dart';
import '../../../providers/firebasertdb_service.dart';
import '../../../providers/storage_service.dart';

class NftGallery extends StatefulWidget {
  const NftGallery({super.key});

  @override
  State<NftGallery> createState() => _NftGalleryState();
}

class _NftGalleryState extends State<NftGallery> {
  List<NftsModel>? dbList = [];
  List<String> urlImages = [];
  bool loading = true;
  late List<Widget> imageSliders;

  Future<void> inni() async {
    var db = Provider.of<DB>(context, listen: false);
    await updateNFT(db.nftlist);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   inni();
  // }

  Future<void> updateNFT(List<NftsModel>? list) async {
    double width = MediaQuery.of(context).size.width;
    loading = true;
    dbList = list;
    if (urlImages.isEmpty) {
      for (var i = 0; i < dbList!.length; i++) {
        urlImages.add(dbList![i].displayURL);
      }
      imageSliders = [];
      for (var i = 0; i < urlImages.length; i++) {
        imageSliders.add(Image.network(urlImages[i], width: width / 2));
      }
      loading = false;
      // setState(() {});
      return;
    } else {
      List<String> tmp = [];
      if (dbList!.length != urlImages.length) {
        for (var i = 0; i < dbList!.length; i++) {
          tmp.add(dbList![i].displayURL);
        }
        for (var i = 0; i < urlImages.length; i++) {
          if (!tmp.contains(urlImages[i])) {
            urlImages.removeAt(i);
          }
        }
        imageSliders = [];
        for (var i = 0; i < urlImages.length; i++) {
          imageSliders.add(Image.network(urlImages[i], width: width / 2));
        }
      }
      loading = false;
      // setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<DB>(builder: (BuildContext context, db, Widget? child) {
      if (db.nftlist != null && db.nftlist != dbList && db.nftlist != []) {
        updateNFT(db.nftlist);
      }
      return urlImages == []
          ? const Text('''No More NFT's Available''')
          : loading
              ? const CircularProgressIndicator()
              : Column(
                  children: imageSliders,
                );
      // Column(
      //   children: [
      //     Row(
      //       children: [
      //         Image.network(urlImages[0], width: width / 2 - 50),
      //         if (urlImages[1].isNotEmpty)
      //           Image.network(urlImages[1], width: width / 2 - 50),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         if (urlImages[2].isNotEmpty)
      //           Image.network(urlImages[2], width: width / 2 - 50),
      //         if (urlImages[3].isNotEmpty)
      //           Image.network(urlImages[3], width: width / 2 - 50),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         if (urlImages[4].isNotEmpty)
      //           Image.network(urlImages[4], width: width / 2 - 50),
      //         if (urlImages[5].isNotEmpty)
      //           Image.network(urlImages[5], width: width / 2 - 50),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         if (urlImages[6].isNotEmpty)
      //           Image.network(urlImages[6], width: width / 2 - 50),
      //         if (urlImages[7].isNotEmpty) Image.network(urlImages[7]),
      //       ],
      //     )
      //   ],
      // );
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: <Widget>[
      //     GridView.builder(
      //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //         maxCrossAxisExtent: 3,
      //         crossAxisSpacing: 5,
      //         mainAxisSpacing: 5,
      //       ),
      //       itemBuilder: (context, index) {
      //         return Image.network(
      //           urlImages[index],
      //           // height: 300,
      //           // fit: BoxFit.cover,
      //         );
      //       },
      //       itemCount: urlImages.length,
      //     )
      //   ],
      // );
    });
  }
}
