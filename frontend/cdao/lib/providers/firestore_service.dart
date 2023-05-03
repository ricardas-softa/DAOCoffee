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
    required int quantity
  }) async {
    CollectionReference ordersReff = firestore.collection('orders');
    int randomNumber =  Random().nextInt(100000);
    bool err = false;
    await ordersReff.doc(randomNumber.toString()).set(
      {
        name: name,
        email: email,
        street1: street1,
        street2: street2,
        city: city,
        state: state,
        zip: zip,
        quantity: quantity
      },
    ).catchError((err) {
      err = true;
    });
    return err;
  }

  Future<String> earlySignUpEmail(
      {required String email,}) async {
    CollectionReference earlyReff = firestore.collection('earlySignUpEmail');
    await earlyReff.add(
      {
        'email': email,
      },
    ).then((value) {
      return value;
    });
    return 'Contact Sent';
  }
}
