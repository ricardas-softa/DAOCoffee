class OrderConstructor {
  late String? tx;
  late String? witness;
  late String? error;

  OrderConstructor({
    this.tx,
    this.witness,
    this.error,
  });

  Map toMap(OrderConstructor order) {
    var data = <String, dynamic>{};
    data["tx"] = order.tx;
    data["witness"] = order.witness;
    data["error"] = order.error;
    return data;
  }

  OrderConstructor.fromMap(Map<String, dynamic> mapData) {
    tx = mapData["tx"];
    witness = mapData["witness"];
    error = mapData["error"];
  }
}
