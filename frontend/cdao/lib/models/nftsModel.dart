class NftsModel {
  late String id;
  late bool available;
  late String displayURL;
  late String ipfsUrl;

  NftsModel({
    required this.id,
    required this.available,
    required this.displayURL,
    required this.ipfsUrl,
  });

  Map toMap(NftsModel nft) {
    var data = <String, dynamic>{};
    data["id"] = nft.id;
    data["available"] = nft.available;
    data["displayURL"] = nft.displayURL;
    data["ipfsUrl"] = nft.ipfsUrl;
    return data;
  }
  
  NftsModel.fromRTDB(nft) {
    try {
      id = nft["id"];
    } catch (e) {
      print('55555555555555555 NftsModel.fromRTDB id ${nft["id"]} error $e');
    }
    try {
      available = nft["available"];
    } catch (e) {
      print('55555555555555555 NftsModel.fromRTDB available ${nft["ipavailablefsUrl"]} error $e');
    }
    try {
      displayURL = nft["displayURL"];
    } catch (e) {
      print('55555555555555555 NftsModel.fromRTDB displayURL ${nft["displayURL"]} error $e');
    }
    try {
      ipfsUrl = nft["ipfsUrl"];
    } catch (e) {
      print('55555555555555555 NftsModel.fromRTDB ipfsUrl ${nft["ipfsUrl"]} error $e');
    }
  }
}
