import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> sendContactForm(
      {required String sendEmailTo,
      required String subject,
      required String emailBody}) async {
    CollectionReference mail = firestore.collection('mail');
    await mail.add(
      {
        'to': sendEmailTo,
        'message': {'subject': subject, 'text': emailBody},
      },
    ).then((value) {
      return value;
    });
    return 'Contact Sent';
  }

  Future<bool> sendOrderForm({
    required String name,
    required String email,
    required String street1,
    required String? street2,
    required String city,
    required String state,
    required int zip,
    required String hash,
    required String nft,
    // required int quantity
  }) async {
    CollectionReference ordersReff = firestore.collection('orders');
    int randomNumber = Random().nextInt(100000);
    bool err = false;
    await ordersReff.doc(randomNumber.toString()).set({
      'id': randomNumber.toString(),
      'name': name,
      'street1': street1,
      'street2': street2,
      'city': city,
      'state': state,
      'zip': zip,
      'email': email,
      'hash': hash,
      'nft': nft,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      // quantity: quantity
    }).catchError((err) {
      print('send order form error $err');
      err = true;
    });
    return err;
  }
}
