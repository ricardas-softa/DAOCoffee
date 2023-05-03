import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'dart:js';
import 'dart:js_util';
import 'package:provider/provider.dart';

// import 'package:address_search_field/address_search_field.dart';
// import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../providers/firestore_service.dart';

class OrderFormDialog extends StatefulWidget {
  const OrderFormDialog({Key? key}) : super(key: key);

  @override
  State<OrderFormDialog> createState() => _OrderFormDialogState();
}

@JS()
external purchaseBackStart();

class _OrderFormDialogState extends State<OrderFormDialog> {
  late String _name;
  late String _email;
  late String _street1;
  late String? _street2;
  late String _city;
  late String _state;
  late int _zip;
  late int _quantity;
  String _err = '';
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  // @JS()
  // external purchaseBackStart();

  @override
  Widget build(BuildContext context) {
    // TODO: add quantity
    Future<String> purchases() async {
      // var obj=  await  promiseToFuture(js.context.callMethod('alwaysSucceed'));
      // js.JsObject obj=  await promiseToFuture(js.context.callMethod('alwaysSucceed'));
      var promise = purchaseBackStart();
      var obj = await promiseToFuture(promise);
      print(obj.toString());
      return obj.toString();
    }

    Future<void> _submitOrderForm() async {
      _isSubmitting = true;
      var firestore = Provider.of<FirestoreService>(context, listen: false);
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        // start purchase
        String result = await purchases();
        if (result != 'fail') {
          bool dbErr = await firestore.sendOrderForm(
              name: _name,
              email: _email,
              street1: _street1,
              street2: _street2,
              city: _city,
              state: _state,
              zip: _zip,
              quantity: _quantity);
          if (dbErr) {
            setState(() {
              _err =
                  'Sorry your purchases did not get recorded. Please contact us asap.';
            });
          }
        } else {
          setState(() {
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
                TextFormField(
                  key: const ValueKey('quantity'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty ||
                        int.parse(value) <= 0 ||
                        int.parse(value) > 5000 ||
                        !isNumeric(value)) {
                      String e =
                          'Please enter a the number of bags of coffee and NFTs you woould like.';
                      setState(() {
                        _err = e;
                        _isSubmitting = false;
                      });
                      return e;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Quantity of coffee bags you uwouuld like.',
                  ),
                  onSaved: (value) {
                    _quantity = int.parse(value!);
                  },
                ),
                // name
                TextFormField(
                  key: const ValueKey('name'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      String e = 'Please enter your name.';
                      setState(() {
                        _err = e;
                        _isSubmitting = false;
                      });
                      return e;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                  ),
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                //email
                TextFormField(
                  key: const ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !EmailValidator.validate(value)) {
                      String e = 'Please enter a valid email address.';
                      setState(() {
                        _err = e;
                        _isSubmitting = false;
                      });
                      return e;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                //street1
                TextFormField(
                  key: const ValueKey('street1'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.streetAddress,
                  // validator: (value) {
                  //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                  //     return 'Please enter a valid email address.';
                  //   }
                  //   return null;
                  // },
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                  ),
                  onSaved: (value) {
                    _street1 = value!;
                  },
                ),
                //street2
                TextFormField(
                  key: const ValueKey('street2'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.streetAddress,
                  // validator: (value) {
                  //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                  //     return 'Please enter a valid email address.';
                  //   }
                  //   return null;
                  // },
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                  ),
                  onSaved: (value) {
                    _street2 = value!;
                  },
                ),
                //city
                TextFormField(
                  key: const ValueKey('city'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  // validator: (value) {
                  //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                  //     return 'Please enter a valid email address.';
                  //   }
                  //   return null;
                  // },
                  decoration: const InputDecoration(
                    labelText: 'City/Town',
                  ),
                  onSaved: (value) {
                    _city = value!;
                  },
                ),
                //state
                TextFormField(
                  key: const ValueKey('state'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  // validator: (value) {
                  //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                  //     return 'Please enter a valid email address.';
                  //   }
                  //   return null;
                  // },
                  decoration: const InputDecoration(
                    labelText: 'State ',
                  ),
                  onSaved: (value) {
                    _state = value!;
                  },
                ),
                //Zip
                TextFormField(
                  key: const ValueKey('zip'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length != 5 ||
                        !isNumeric(value)) {
                      String e = 'Please enter a valid zip code.';
                      setState(() {
                        _err = e;
                        _isSubmitting = false;
                      });
                      return e;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Zip Code',
                  ),
                  onSaved: (value) {
                    _zip = int.parse(value!);
                  },
                ),
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
