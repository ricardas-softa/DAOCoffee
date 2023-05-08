class OrderModel {
  late String id;
  late String email;
  late String street1;
  late String street2;
  late String city;
  late String state;
  late String nftId;
  late int zip;
  late int hash;
  late String timestamp;

  OrderModel({
    required this.id,
    required this.email,
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.zip,
    required this.nftId,
    required this.hash,
    required this.timestamp,
  });

  Map toMap(OrderModel order) {
    var data = <String, dynamic>{};
    data["id"] = order.id;
    data["email"] = order.email;
    data["street1"] = order.street1;
    data["street2"] = order.street2;
    data["city"] = order.city;
    data["state"] = order.state;
    data["zip"] = order.zip;
    data["nftId"] = order.nftId;
    data["hash"] = order.hash;
    data["timestamp"] = order.timestamp;
    return data;
  }

  OrderModel.fromMap(Map<String, dynamic> mapData) {
    id = mapData["id"];
    email = mapData["email"];
    street1 = mapData["street1"];
    street2 = mapData["street2"];
    city = mapData["city"];
    zip = mapData["zip"];
    nftId = mapData["nftId"];
    hash = mapData["hash"];
    timestamp = mapData["timestamp"].toString();
  }
}
