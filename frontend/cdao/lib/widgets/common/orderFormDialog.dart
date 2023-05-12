// import 'dart:convert';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;

// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:js/js.dart';
// import 'dart:js';
// import 'dart:js_util';
// import 'package:provider/provider.dart';

// // import 'package:address_search_field/address_search_field.dart';
// // import 'package:location/location.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../../models/mintResponse.dart';
// import '../../models/nftsModel.dart';
// import '../../models/orderCunstructorResponse.dart';
// import '../../providers/firebasertdb_service.dart';
// import '../../providers/firestore_service.dart';
// import '../../screens/receiptScreen.dart';

// class OrderFormDialog extends StatefulWidget {
//   const OrderFormDialog({Key? key}) : super(key: key);

//   @override
//   State<OrderFormDialog> createState() => _OrderFormDialogState();
// }

// @JS()
// external purchaseFrontStart(nftId);

// class _OrderFormDialogState extends State<OrderFormDialog> {
//   String _err = '';
//   bool _isSubmitting = false;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     late NftsModel nft;
//     // late int quantity;
//     late String name;
//     late String email;
//     late String street1;
//     late String? street2;
//     late String city;
//     late String state;
//     late int zip;
//     // late String hash;
//     String nameError = '';
//     String streetError = '';
//     String cityError = '';
//     String stateError = '';
//     String zipError = '';
//     String emailError = '';

//     Future<void> getNft() async {
//       var db = Provider.of<DB>(context, listen: false);
//       nft = await db.getNft();
//       setState(() {});
//       return;
//     }

//     Future<Map<String, String>> _submitOrderForm(context) async {
//       late String? hash;
//       _isSubmitting = true;
//       var firestore = Provider.of<FirestoreService>(context, listen: false);
//       var db = Provider.of<DB>(context, listen: false);
//       final isValid = _formKey.currentState!.validate();
//       if (isValid) {
//         _formKey.currentState!.save();
//         await getNft();
//         var promise = purchaseFrontStart(nft.id);
//         await promiseToFuture(promise).then((value) async {
//           if (value != null && value != Null) {
//             OrderConstructor order =
//                 OrderConstructor.fromMap(json.decode(value));
//             http.Response response = await http
//                 .post(
//                     Uri.parse('https://cdao-mint-tm7praakga-uc.a.run.app/mint'),
//                     headers: <String, String>{
//                       'Content-Type': 'application/json; charset=UTF-8',
//                     },
//                     body: jsonEncode(<String, String>{
//                       'witness': order.witness as String,
//                       'tx': order.tx as String
//                     }))
//                 .then((value) {
//               if (value.statusCode == 200) {
//                 MintResponse result =
//                     MintResponse.fromMap(json.decode(value.body.toString()));
//                 if (result.txhash != null) {
//                   // print(
//                   //     'MintResponse result.txhash ${result.txhash.runtimeType} ${result.txhash}');
//                   hash = result.txhash as String;
//                 } else {
//                   print(
//                       'MintResponse result.txhash ${result.error.runtimeType} ${result.error}');
//                   hash = 'error';
//                   // _err = '${result.error}';
//                 }
//                 return value;
//               } else {
//                 hash = 'error';
//                 return value;
//               }
//             });
//           }
//         }).then((v) async {
//           // print('then((v) hash $hash');
//           if (hash != null || !hash!.contains('error')) {
//             // print('if (!hash.contains $hash');
//             bool dbErr = await firestore.sendOrderForm(
//               name: name,
//               street1: street1,
//               street2: street2,
//               city: city,
//               state: state,
//               zip: zip,
//               email: email,
//               hash: hash!,
//               nft: nft.id,
//               // quantity: _quantity
//             );
//             if (dbErr) {
//               print('99999999999999999999 order db entry error');
//               setState(() {
//                 _isSubmitting = false;
//                 _err =
//                     'Sorry your purchases did not go through please try again.';
//               });
//               hash = _err;
//               return {'error': _err};
//             } else {
//               await db.updateNft(nft.id);
//               return {'hash': hash, 'nftUrl': nft.ipfsUrl};
//               // context.push('/receipt',
//               //     extra: {'hash': hash, 'nftUrl': nft.ipfsUrl});
//               // GoRouter.of(context)
//               //     .go('/receipt', extra: {'hash': hash, 'nftUrl': nft.ipfsUrl});
//               // Navigator.of(context).push(
//               //   MaterialPageRoute(
//               //     builder: (context) => ReceiptScreen(hash: hash!, nftUrl: nft.ipfsUrl,),
//               //   ),
//               // );
//             }
//           } else {
//             print('hash.contains(error))');
//             _isSubmitting = false;
//             _err = 'Sorry your purchases did not go through please try again.';
//           }
//         });
//       } else {
//         print('999999999999999999999999999 not valid');
//         _err = 'Sorry your purchases did not go through please try again.';
//         hash = _err;
//       }
//       print('_submitOrderForm done');
//       if (hash == _err) {
//         _isSubmitting = false;
//         return {'error': _err};
//       } else {
//         _isSubmitting = false;
//         return {'hash': hash!, 'nftUrl': nft.ipfsUrl};
//       }
//     }

//     bool isNumeric(String s) {
//       try {
//         int.parse(s);
//       } catch (e) {
//         return false;
//       }
//       return true;
//     }

//     return Dialog(
//         backgroundColor: Colors.blueGrey,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: SingleChildScrollView(
//             child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 if (_err != '')
//                   Text(
//                     _err,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 const Text('We need a little information for shipping.',
//                     textAlign: TextAlign.center
//                     // style: TextStyle(color: Colors.white),
//                     ),
//                 //quantity
//                 // TextFormField(
//                 //   key: const ValueKey('quantity'),
//                 //   autocorrect: false,
//                 //   textCapitalization: TextCapitalization.none,
//                 //   enableSuggestions: false,
//                 //   keyboardType: TextInputType.number,
//                 //   validator: (value) {
//                 //     if (value!.isEmpty ||
//                 //         int.parse(value) <= 0 ||
//                 //         int.parse(value) > 5000 ||
//                 //         !isNumeric(value)) {
//                 //       String e =
//                 //           'Please enter a the number of bags of coffee and NFTs you woould like.';
//                 //       setState(() {
//                 //         _err = e;
//                 //         _isSubmitting = false;
//                 //       });
//                 //       return e;
//                 //     }
//                 //     return null;
//                 //   },
//                 //   decoration: const InputDecoration(
//                 //     labelText: 'Quantity of coffee bags you uwouuld like.',
//                 //   ),
//                 //   onSaved: (value) {
//                 //     _quantity = int.parse(value!);
//                 //   },
//                 // ),
//                 TextFormField(
//                   key: const ValueKey('name'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.text,
//                   // validator: (value) {
//                   //   if (value!.isEmpty) {
//                   //     nameError = '''Please enter your name.''';
//                   //     _isSubmitting = false;
//                   //     setState(() {});
//                   //     return nameError;
//                   //   } else {
//                   //     nameError = '';
//                   //     setState(() {});
//                   //     return nameError;
//                   //   }
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'Your Name',
//                   ),
//                   onSaved: (value) {
//                     name = value!;
//                   },
//                 ),
//                 nameError == ''
//                     ? const SizedBox(
//                         height: 0,
//                       )
//                     : Text(
//                         nameError,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                 //email
//                 TextFormField(
//                   key: const ValueKey('email'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.emailAddress,
//                   // validator: (value) {
//                   //   if (value!.isEmpty || !EmailValidator.validate(value)) {
//                   //     emailError = '''Please enter a valid email.''';
//                   //     _isSubmitting = false;
//                   //     setState(() {});
//                   //     return emailError;
//                   //   } else {
//                   //     emailError = '';
//                   //     setState(() {});
//                   //     return emailError;
//                   //   }
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                   ),
//                   onSaved: (value) {
//                     email = value!;
//                   },
//                 ),
//                 emailError == ''
//                     ? const SizedBox(
//                         height: 0,
//                       )
//                     : Text(
//                         emailError,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                 //street1
//                 TextFormField(
//                   key: const ValueKey('street1'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.streetAddress,
//                   // validator: (value) {
//                   //   if (value!.isEmpty) {
//                   //     streetError = '''Please enter your street address.''';
//                   //     _isSubmitting = false;
//                   //     setState(() {});
//                   //     return streetError;
//                   //   } else {
//                   //     streetError = '';
//                   //     setState(() {});
//                   //     return streetError;
//                   //   }
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'Street Address',
//                   ),
//                   onSaved: (value) {
//                     street1 = value!;
//                   },
//                 ),
//                 streetError == ''
//                     ? const SizedBox(
//                         height: 0,
//                       )
//                     : Text(
//                         streetError,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                 //street2
//                 TextFormField(
//                   key: const ValueKey('street2'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.streetAddress,
//                   // validator: (value) {
//                   //   if (value!.isEmpty || !EmailValidator.validate(value)) {
//                   //     return 'Please enter a valid email address.';
//                   //   }
//                   //   return null;
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'Street Address',
//                   ),
//                   onSaved: (value) {
//                     street2 = value!;
//                   },
//                 ),
//                 //city
//                 TextFormField(
//                   key: const ValueKey('city'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.text,
//                   // validator: (value) {
//                   //   if (value!.isEmpty) {
//                   //     cityError = '''Please enter your city or town's name.''';
//                   //     _isSubmitting = false;
//                   //     setState(() {});
//                   //     return cityError;
//                   //   } else {
//                   //     cityError = '';
//                   //     setState(() {});
//                   //     return cityError;
//                   //   }
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'City/Town',
//                   ),
//                   onSaved: (value) {
//                     city = value!;
//                   },
//                 ),
//                 cityError == ''
//                     ? const SizedBox(
//                         height: 0,
//                       )
//                     : Text(
//                         cityError,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                 //state
//                 TextFormField(
//                   key: const ValueKey('state'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.text,
//                   // validator: (value) {
//                   //   if (value!.isEmpty || value.length != 2) {
//                   //     stateError = 'Please enter the state abbreviation.';
//                   //     _isSubmitting = false;
//                   //     setState(() {});
//                   //     return stateError;
//                   //   } else {
//                   //     stateError = '';
//                   //     setState(() {});
//                   //     return stateError;
//                   //   }
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'State Abbreviation',
//                   ),
//                   onSaved: (value) {
//                     state = value!;
//                   },
//                 ),
//                 stateError == ''
//                     ? const SizedBox(
//                         height: 0,
//                       )
//                     : Text(
//                         stateError,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                 //Zip
//                 TextFormField(
//                   key: const ValueKey('zip'),
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   enableSuggestions: false,
//                   keyboardType: TextInputType.number,
//                   // validator: (value) {
//                   //   if (value!.isEmpty ||
//                   //       value.length != 5 ||
//                   //       !isNumeric(value)) {
//                   //     setState(() {
//                   //       zipError = 'Please enter a valid zip code.';
//                   //       _isSubmitting = false;
//                   //     });
//                   //     return zipError;
//                   //   } else {
//                   //     zipError = '';
//                   //     setState(() {
//                   //       zipError = '';
//                   //     });
//                   //     return zipError;
//                   //   }
//                   // },
//                   decoration: const InputDecoration(
//                     labelText: 'Zip Code',
//                   ),
//                   onSaved: (value) {
//                     zip = int.parse(value!);
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 zipError == ''
//                     ? const SizedBox(
//                         height: 0,
//                       )
//                     : Text(
//                         zipError,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                 const SizedBox(height: 12),
//                 _isSubmitting
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: () async =>
//                             await _submitOrderForm(context).then((value) {
//                           print('going to receipt value $value');
//                           context.go( '/receipt/${value['hash']}/${value['nftUrl']}');
//                           // GoRouter.of(context)
//                           //     .go('/receipt', extra: value);
//                           // Navigator.of(context).popAndPushNamed('/receipt', arguments: value
//                           // MaterialPageRoute(
//                           //   builder: (context) => ReceiptScreen(hash: hash!, nftUrl: nft.ipfsUrl,),
//                           // ),
//                           // );
//                         }),
//                         child: const Text('Submit'),
//                       ),
//               ],
//             ),
//           ),
//         )));
//   }
// }
