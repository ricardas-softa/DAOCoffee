import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/nftsModel.dart';
import '../../../providers/firebasertdb_service.dart';
import '../../../routes/route_const.dart';
import '../../../widgets/common/NftGallery/nftGallery.dart';
import '../../../widgets/common/title.dart';
import '../../../widgets/farm/FarmCarasole.dart';
import '../../../widgets/farm/farmHeader.dart';

class LosHornosScreen extends StatefulWidget {
  const LosHornosScreen({super.key});

  @override
  State<LosHornosScreen> createState() => _LosHornosScreenState();
}

class _LosHornosScreenState extends State<LosHornosScreen> {
  int? minted;

  Future<void> setup() async {
    var db = Provider.of<DB>(context, listen: false);
    minted = await db.getMinted();
    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<String> getNft() async {
    var db = Provider.of<DB>(context, listen: false);
    NftsModel nft = await db.getNft();
    await db.updateNft(nft.id, false);
    return '''{"id":"${nft.id}", "available": "${nft.available}", "displayURL": "${nft.displayURL}", "ipfsUrl": "${nft.ipfsUrl}"}''';
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double boxH = 20;
    double fontS = 20;
    double wordSpaceing = 2;
    return Consumer<DB>(builder: (context, db, child) {
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
                  children: [
                    FarmHeader(
                      farmName: 'losHornos',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: mWidth,
                      height: mWidth / 3,
                      child: FarmCarasole(
                        farmName: 'losHornos', // firebase storage farm name
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // description of the projecct
                        Container(
                          // color: Colors.blueGrey,
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  '''CoffeeDAO is an initiative to attach an NFT with each coffee bag sold on our platform. This provides consumers with the origin of the coffee, characteristics of the coffee, and the artistic process used in  the production by the grower. For producers, it creates a record of the consistent quality of their product and a direct link with the coffee drinkers that buy their coffee.''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontS, height: wordSpaceing),
                                ),
                                SizedBox(
                                  height: boxH,
                                ),
                                Text(
                                  '''This is a single origin coffee, cultivated 460 feet above sea level, in the mountains of Concepción de Los Hornos, Comayagua, Honduras, by the artisan Mr. Nelvin Humberto Baquis at the Finca "La Casona" and "El Ocotialto". With special care in preparing the land and preserving the environment, using compost, from anaerobic biodigesters and formula for fertilization. The cultivated coffee tree's species are from the Timor and Villa Sarchí families, specifically Parainema as well as other PACA and H-90 species. In the same way, the flowers of the surrounding plants, such as citrus and cherries fruits, are used to favor the coffee unique aroma during the bee pollination process.''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontS, height: wordSpaceing),
                                ),
                                SizedBox(
                                  height: boxH,
                                ),
                                Text(
                                  '''After individually harvesting the coffee cherries, a manual screening is carried out eliminating natural defects. The pulp is removed and washed in an ordinary case, and then dried at outdoor temperature until reaching an optimal humidity of 11% per batch. Subsequently, the parchment, a natural membrane that covers the bean, is removed and ready for a medium roast. It's important to carefully control the roasting mechanisms maintaining the balance of time by volume of each batch and air to bean ratio, ending with rapid cooling process to preserve the aromas.''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontS, height: wordSpaceing),
                                ),
                                Text(
                                  '''This coffee's profile aroma is 84%, a creamy texture with dark sweet chocolate fragrances and mandarin and orange citrus tones. The ways to enjoy your coffee beans varies and it's recommended to keep your samples at a cold temperature and grind it in a suitable mill, just before making the infusion. ''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontS, height: wordSpaceing),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: boxH,
                        ),
                        // TODO: update short description of the purchasing process
                        // const Text(
                        //   ''' Description of the purchasing process: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''',
                        //   textAlign: TextAlign.center,
                        // ),
                        SizedBox(
                          height: boxH,
                        ),
                        minted == null || minted! >= 5000
                            ? Text(
                                'Nothing to mint today.',
                                style: TextStyle(fontSize: fontS),
                              )
                            : Column(
                              children: const [
                                Text('''Los Hornos NFT's''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 60),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('''The NFT originals do not have the NFTDAO watermark.''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                NftGallery(),
                              ],
                            ),
                        SizedBox(
                          height: boxH,
                        ),
                        minted == null || minted! >= 5000
                            ? const SizedBox(
                                height: 0,
                              )
                            : const Text(
                                '''A Cardano NFT & One Pound of Premium Honduran Coffee for 45 ADA''',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40),
                              ),
                        SizedBox(
                          height: boxH,
                        ),
                        // TODO: update coffee bag image
                        minted == null || minted! >= 5000
                            ? const SizedBox(
                                height: 0,
                              )
                            : Image.asset(
                                'lib/assets/images/Coffee-Packaging.jpg',
                                width: mWidth / 5,
                              ),
                        SizedBox(
                          height: boxH,
                        ),
                        minted == null || minted! >= 5000
                            ? const SizedBox(
                                height: 0,
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  getNft().then((value) {
                                    context.goNamed(CDAOConstants.orderRoute,
                                        params: {"nftm": value});
                                  });
                                },
                                child: const Text(
                                  'BUY NOW',
                                  style: TextStyle(fontSize: 40),
                                )),
                      ]),
                ),
              ],
            ),
          ));
    });
  }
}