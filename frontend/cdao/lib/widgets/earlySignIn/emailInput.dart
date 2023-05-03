import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/firebasertdb_service.dart';

class EmailInputField extends StatefulWidget {
  const EmailInputField({super.key});

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  String? email1;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<DB>(builder: (context, db, child) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: width,
                height: 100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          errorText: errorMessage,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              email1 = null;
                              errorMessage = 'Please enter some text';
                            });
                            return 'Please enter some text';
                          } else {
                            if (!EmailValidator.validate(value)) {
                              setState(() {
                                email1 = null;
                                errorMessage = 'Please enter a valid email';
                              });
                              return 'Please enter a valid email';
                            } else {
                              setState(() {
                                email1 = value;
                              });
                              return null;
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                db.notifyEntery(email1 as String);
              }
            },
            child: const Text('NOTIFY ME!'),
          ),
        ],
      );
    });
  }
}
