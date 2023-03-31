import 'dart:async';
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
