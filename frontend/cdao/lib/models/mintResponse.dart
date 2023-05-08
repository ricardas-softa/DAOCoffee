class MintResponse {
  late String? txhash;
  late String? error;

  MintResponse({
    this.txhash,
    this.error,
  });

  Map toMap(MintResponse order) {
    var data = <String, dynamic>{};
    data["txhash"] = order.txhash;
    data["error"] = order.error;
    return data;
  }

  MintResponse.fromMap(Map<String, dynamic> mapData) {
    txhash = mapData["txhash"];
    error = mapData["error"];
  }
}
