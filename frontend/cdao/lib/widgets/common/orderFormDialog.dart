import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'dart:js';
import 'dart:js_util';
import 'package:provider/provider.dart';

// import 'package:address_search_field/address_search_field.dart';
// import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/mintResponse.dart';
import '../../models/orderCunstructorResponse.dart';
import '../../providers/firestore_service.dart';

class OrderFormDialog extends StatefulWidget {
  const OrderFormDialog({Key? key}) : super(key: key);

  @override
  State<OrderFormDialog> createState() => _OrderFormDialogState();
}

@JS()
external purchaseFrontStart();

class _OrderFormDialogState extends State<OrderFormDialog> {
  String _err = '';
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String name = "Test";
    String email = "test@test.com";
    String street1 = "Test";
    String? street2;
    String city = "Test";
    String state = "NM";
    int zip = 87104;
    // TODO: add quantity

    Future<String> purchases() async {
      var promise = purchaseFrontStart();
      String hash = '';
      promiseToFuture(promise).asStream().listen((value) async {
        if (value != null && value != Null) {
          OrderConstructor order = OrderConstructor.fromMap(json.decode(value));
          print(
              'OrderConstructor order.tx: ${order.tx.runtimeType} ${order.tx}');
          print(
              'OrderConstructor order.witness: ${order.witness.runtimeType} ${order.witness}');
          // String data = '''{
          //   "name": "$name",
          //   "witness": "${order.witness}",
          //   "tx": "${order.tx}"
          // }''';
          http.Response response = await http.post(
            Uri.parse('https://cdao-mint-tm7praakga-uc.a.run.app/mint'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'name': name,
              'witness': order.witness as String,
              'tx': order.tx as String 
            })
          );
          print(
              'http.Response response.body ${response.body.runtimeType} ${response.body}');
          if (response.statusCode == 200) {
            MintResponse result =
                MintResponse.fromMap(json.decode(response.body.toString()));
            print('MintResponse result ${result.runtimeType} $result');
            if (result.txhash != null) {
              print('MintResponse result.txhash ${result.txhash.runtimeType} ${result.txhash}');
              hash = result.txhash as String;
            } else {
              print('MintResponse result.txhash ${result.error.runtimeType} ${result.error}');
              hash = 'error';
              _err = '${result.error}';
            }
            return;
          } else {
            hash = 'error';
            _err = 'Sorry your purchases did not go through please try again.';
            return;
          }
        }
      });
      return hash;
    }

    Future<void> _submitOrderForm() async {
      _isSubmitting = true;
      var firestore = Provider.of<FirestoreService>(context, listen: false);
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        // String result = await purchases();
        String hash = await purchases();
        if (!hash.contains('error')) {
          bool dbErr = await firestore.sendOrderForm(
            name: name,
            email: email,
            street1: street1,
            street2: street2,
            city: city,
            state: state,
            zip: zip,
            hash: hash,
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            // quantity: _quantity
          );
          if (dbErr) {
            setState(() {
              _isSubmitting = false;
              _err =
                  'Sorry your purchases did not go through please try again.';
            });
          } else {
            Navigator.pop(context);
          }
        } else {
          setState(() {
            _isSubmitting = false;
            _err = 'Sorry your purchases did not go through please try again.';
          });
        }
      }
    }

    bool isNumeric(String s) {
      try {
        int.parse(s);
      } catch (e) {
        return false;
      }
      return true;
    }

    return Dialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (_err != '')
                  Text(
                    _err,
                    style: const TextStyle(color: Colors.red),
                  ),
                //quantity
                // TextFormField(
                //   key: const ValueKey('quantity'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.number,
                //   validator: (value) {
                //     if (value!.isEmpty ||
                //         int.parse(value) <= 0 ||
                //         int.parse(value) > 5000 ||
                //         !isNumeric(value)) {
                //       String e =
                //           'Please enter a the number of bags of coffee and NFTs you woould like.';
                //       setState(() {
                //         _err = e;
                //         _isSubmitting = false;
                //       });
                //       return e;
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Quantity of coffee bags you uwouuld like.',
                //   ),
                //   onSaved: (value) {
                //     _quantity = int.parse(value!);
                //   },
                // ),
                const Text(
                  'We need a little information for shipping.',
                  style: TextStyle(color: Colors.white),
                ),
                // TextFormField(
                //   key: const ValueKey('name'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.text,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       String e = 'Please enter your name.';
                //       setState(() {
                //         _err = e;
                //         _isSubmitting = false;
                //       });
                //       return e;
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Your Name',
                //   ),
                //   onSaved: (value) {
                //     name = value!;
                //   },
                // ),
                // //email
                // TextFormField(
                //   key: const ValueKey('email'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.emailAddress,
                //   validator: (value) {
                //     if (value!.isEmpty || !EmailValidator.validate(value)) {
                //       String e = 'Please enter a valid email address.';
                //       setState(() {
                //         _err = e;
                //         _isSubmitting = false;
                //       });
                //       return e;
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Email',
                //   ),
                //   onSaved: (value) {
                //     email = value!;
                //   },
                // ),
                // //street1
                // TextFormField(
                //   key: const ValueKey('street1'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.streetAddress,
                //   // validator: (value) {
                //   //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                //   //     return 'Please enter a valid email address.';
                //   //   }
                //   //   return null;
                //   // },
                //   decoration: const InputDecoration(
                //     labelText: 'Street Address',
                //   ),
                //   onSaved: (value) {
                //     street1 = value!;
                //   },
                // ),
                // //street2
                // TextFormField(
                //   key: const ValueKey('street2'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.streetAddress,
                //   // validator: (value) {
                //   //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                //   //     return 'Please enter a valid email address.';
                //   //   }
                //   //   return null;
                //   // },
                //   decoration: const InputDecoration(
                //     labelText: 'Street Address',
                //   ),
                //   onSaved: (value) {
                //     street2 = value!;
                //   },
                // ),
                // //city
                // TextFormField(
                //   key: const ValueKey('city'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.text,
                //   // validator: (value) {
                //   //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                //   //     return 'Please enter a valid email address.';
                //   //   }
                //   //   return null;
                //   // },
                //   decoration: const InputDecoration(
                //     labelText: 'City/Town',
                //   ),
                //   onSaved: (value) {
                //     city = value!;
                //   },
                // ),
                // //state
                // TextFormField(
                //   key: const ValueKey('state'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.text,
                //   // validator: (value) {
                //   //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                //   //     return 'Please enter a valid email address.';
                //   //   }
                //   //   return null;
                //   // },
                //   decoration: const InputDecoration(
                //     labelText: 'State ',
                //   ),
                //   onSaved: (value) {
                //     state = value!;
                //   },
                // ),
                // //Zip
                // TextFormField(
                //   key: const ValueKey('zip'),
                //   autocorrect: false,
                //   textCapitalization: TextCapitalization.none,
                //   enableSuggestions: false,
                //   keyboardType: TextInputType.number,
                //   validator: (value) {
                //     if (value!.isEmpty ||
                //         value.length != 5 ||
                //         !isNumeric(value)) {
                //       String e = 'Please enter a valid zip code.';
                //       setState(() {
                //         _err = e;
                //         _isSubmitting = false;
                //       });
                //       return e;
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Zip Code',
                //   ),
                //   onSaved: (value) {
                //     zip = int.parse(value!);
                //   },
                // ),
                const SizedBox(height: 12),
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _submitOrderForm(),
                        child: const Text('Submit'),
                      ),
              ],
            ),
          ),
        )));
  }
}
