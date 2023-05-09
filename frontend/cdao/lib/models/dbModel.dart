class DBModel {
  late String? txhash;
  late String? error;

  DBModel({
    this.txhash,
    this.error,
  });

  Map toMap(DBModel order) {
    var data = <String, dynamic>{};
    data["txhash"] = order.txhash;
    data["error"] = order.error;
    return data;
  }

  DBModel.fromMap(Map<String, dynamic> mapData) {
    txhash = mapData["txhash"];
    error = mapData["error"];
  }
}
