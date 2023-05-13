import 'dart:convert';
import 'package:go_router/go_router.dart';
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
import '../../models/nftsModel.dart';
import '../../models/orderCunstructorResponse.dart';
import '../../providers/firebasertdb_service.dart';
import '../../providers/firestore_service.dart';
import '../routes/route_const.dart';
import '../widgets/common/title.dart';

class OrderFormScreen extends StatefulWidget {
  final String nftm;
  const OrderFormScreen({required this.nftm, super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

@JS()
external purchaseFrontStart(nftId);

class _OrderFormScreenState extends State<OrderFormScreen> {
  String _err = '';
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  NftsModel? nft;
  bool loading = true;

  Future<void> inni() async {
    Map x = await json.decode(widget.nftm);
    bool b = x['available'] == 'true';
    Map y = {
      "id": x['id'],
      "available": b,
      "displayURL": x['displayURL'],
      "ipfsUrl": x['ipfsUrl']
    };
    nft = NftsModel.fromRTDB(y);
    loading = false;
  }

  @override
  void initState() {
    super.initState();
    inni();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // late int quantity;
    late String name;
    late String email;
    late String street1;
    late String? street2;
    late String city;
    late String state;
    late int zip;
    // late String hash;
    String nameError = '';
    String streetError = '';
    String cityError = '';
    String stateError = '';
    String zipError = '';
    String emailError = '';

    Future<Map<String, String>> _submitOrderForm() async {
      late String? hash;
      _isSubmitting = true;
      var firestore = Provider.of<FirestoreService>(context, listen: false);
      var db = Provider.of<DB>(context, listen: false);
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        var promise = purchaseFrontStart(nft!.id);
        await promiseToFuture(promise).then((value) async {
          if (value != null && value != Null) {
            OrderConstructor order =
                OrderConstructor.fromMap(json.decode(value));
            await http
                .post(
                    Uri.parse('https://cdao-mint-tm7praakga-uc.a.run.app/mint'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'witness': order.witness as String,
                      'tx': order.tx as String
                    }))
                .then((value) {
              if (value.statusCode == 200) {
                MintResponse result =
                    MintResponse.fromMap(json.decode(value.body.toString()));
                if (result.txhash != null) {
                  hash = result.txhash as String;
                } else {
                  hash = 'error';
                }
                return value;
              } else {
                hash = 'error';
                return value;
              }
            });
          }
        }).then((v) async {
          if (hash != null || !hash!.contains('error')) {
            bool dbErr = await firestore.sendOrderForm(
              name: name,
              street1: street1,
              street2: street2,
              city: city,
              state: state,
              zip: zip,
              email: email,
              hash: hash!,
              nft: nft!.id,
              // quantity: _quantity
            );
            if (dbErr) {
              print('99999999999999999999 order db entry error');
              setState(() {
                _isSubmitting = false;
                _err =
                    '''Sorry your purchases did not get recorded. Please reach out to us.''';
              });
              await db.incrementSold(1);
              return {'hash': hash, 'nftUrl': nft!.ipfsUrl};
            } else {
              await db.incrementSold(1);
              return {'hash': hash, 'nftUrl': nft!.ipfsUrl};
            }
          } else {
            await db.updateNft(nft!.id, true);
            print('hash.contains(error))');
            _isSubmitting = false;
            _err = 'Sorry your purchases did not go through please try again.';
          }
        });
      } else {
        await db.updateNft(nft!.id, true);
        print('999999999999999999999999999 not valid');
        _err = 'Sorry your purchases did not go through please try again.';
        hash = _err;
      }
      if (hash == _err) {
        await db.updateNft(nft!.id, true);
        _isSubmitting = false;
        return {'error': _err};
      } else {
        _isSubmitting = false;
        return {'hash': hash!, 'nftUrl': nft!.displayURL};
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

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: width < 753 ? 65 : 130,
          backgroundColor: Colors.black,
          title: Padding(
            padding: EdgeInsets.all(width < 753 ? 20 : 40.0),
            child: TitleWidget(size: width < 753 ? 25 : 50),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    if (_err != '')
                      Text(
                        _err,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const Text(
                      'Your NFT',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.orange, fontSize: 60),
                    ),
                    const Text(
                      '''The original that you will receive will not have the NFTDAO watermark.''',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    loading
                        ? const CircularProgressIndicator()
                        : Image.network(nft!.displayURL),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'We need a little information for shipping.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
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
                    TextFormField(
                      key: const ValueKey('name'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     nameError = '''Please enter your name.''';
                      //     _isSubmitting = false;
                      //     setState(() {});
                      //     return nameError;
                      //   } else {
                      //     nameError = '';
                      //     setState(() {});
                      //     return nameError;
                      //   }
                      // },
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                      ),
                      onSaved: (value) {
                        name = value!;
                      },
                    ),
                    nameError == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            nameError,
                            style: const TextStyle(color: Colors.red),
                          ),
                    //email
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      // validator: (value) {
                      //   if (value!.isEmpty || !EmailValidator.validate(value)) {
                      //     emailError = '''Please enter a valid email.''';
                      //     _isSubmitting = false;
                      //     setState(() {});
                      //     return emailError;
                      //   } else {
                      //     emailError = '';
                      //     setState(() {});
                      //     return emailError;
                      //   }
                      // },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onSaved: (value) {
                        email = value!;
                      },
                    ),
                    emailError == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            emailError,
                            style: const TextStyle(color: Colors.red),
                          ),
                    //street1
                    TextFormField(
                      key: const ValueKey('street1'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.streetAddress,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     streetError = '''Please enter your street address.''';
                      //     _isSubmitting = false;
                      //     setState(() {});
                      //     return streetError;
                      //   } else {
                      //     streetError = '';
                      //     setState(() {});
                      //     return streetError;
                      //   }
                      // },
                      decoration: const InputDecoration(
                        labelText: 'Street Address',
                      ),
                      onSaved: (value) {
                        street1 = value!;
                      },
                    ),
                    streetError == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            streetError,
                            style: const TextStyle(color: Colors.red),
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
                        street2 = value!;
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
                      //   if (value!.isEmpty) {
                      //     cityError = '''Please enter your city or town's name.''';
                      //     _isSubmitting = false;
                      //     setState(() {});
                      //     return cityError;
                      //   } else {
                      //     cityError = '';
                      //     setState(() {});
                      //     return cityError;
                      //   }
                      // },
                      decoration: const InputDecoration(
                        labelText: 'City/Town',
                      ),
                      onSaved: (value) {
                        city = value!;
                      },
                    ),
                    cityError == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            cityError,
                            style: const TextStyle(color: Colors.red),
                          ),
                    //state
                    TextFormField(
                      key: const ValueKey('state'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value!.isEmpty || value.length != 2) {
                      //     stateError = 'Please enter the state abbreviation.';
                      //     _isSubmitting = false;
                      //     setState(() {});
                      //     return stateError;
                      //   } else {
                      //     stateError = '';
                      //     setState(() {});
                      //     return stateError;
                      //   }
                      // },
                      decoration: const InputDecoration(
                        labelText: 'State Abbreviation',
                      ),
                      onSaved: (value) {
                        state = value!;
                      },
                    ),
                    stateError == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            stateError,
                            style: const TextStyle(color: Colors.red),
                          ),
                    //Zip
                    TextFormField(
                      key: const ValueKey('zip'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.number,
                      // validator: (value) {
                      //   if (value!.isEmpty ||
                      //       value.length != 5 ||
                      //       !isNumeric(value)) {
                      //     setState(() {
                      //       zipError = 'Please enter a valid zip code.';
                      //       _isSubmitting = false;
                      //     });
                      //     return zipError;
                      //   } else {
                      //     zipError = '';
                      //     setState(() {
                      //       zipError = '';
                      //     });
                      //     return zipError;
                      //   }
                      // },
                      decoration: const InputDecoration(
                        labelText: 'Zip Code',
                      ),
                      onSaved: (value) {
                        zip = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 12),
                    zipError == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            zipError,
                            style: const TextStyle(color: Colors.red),
                          ),
                    const SizedBox(height: 12),
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              await _submitOrderForm().then((value) {
                                String x = '''{"hash": ${value['hash']}, "nftUrl": "${value['nftUrl']}"}''';
                                context.goNamed(CDAOConstants.receiptRoute,
                                    params: {"data": x});
                              });
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
