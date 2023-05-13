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
    id = nft["id"];
    available = nft["available"];
    displayURL = nft["displayURL"];
    ipfsUrl = nft["ipfsUrl"];
  }
}
