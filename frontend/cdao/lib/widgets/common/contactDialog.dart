import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/firestore_service.dart';

class ContactDialog extends StatefulWidget {
  const ContactDialog({Key? key}) : super(key: key);

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  late String _name;
  late String _email;
  late String _message;
  late String _emailErr = '';
  final bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  bool validateEmail(String value) {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailPattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {    
    var firestore = Provider.of<FirestoreService>(context, listen: false);

    Future<void> _submitContactForm() async {
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        await firestore.sendContactForm(
                sendEmailTo: 'contact@disasterprediction.app',
                subject: 'DPA Contact From ',
                emailBody: "$_name email: $_email $_message")
            .then((value) {
          if (value == 'Contact Sent') {
            firestore.sendContactForm(
                sendEmailTo: _email,
                subject: 'Thanks for reaching out to The DPA',
                emailBody:
                    "Hi $_name, Please give us a few days to review your message and respond. Thanks The DPA Team");
            Navigator.pop(context, 'result');
          } else {
            _emailErr = 'Something did not go as planed. Please try again.';
          }
        });
      }
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
                if (_emailErr != '')
                  Text(
                    _emailErr,
                    style: const TextStyle(color: Colors.red),
                  ),
                //name
                TextFormField(
                  key: const ValueKey('name'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Name'),
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
                    if (value!.isEmpty || validateEmail(value) != true) {
                      return 'Please enter a valid email address.';
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
                //Message
                SingleChildScrollView(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null, //grow automatically
                    key: const ValueKey('message'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Can\'t be empty.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tell us your thoughts.',
                    ),
                    onSaved: (value) {
                      _message = value as String;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (_isSubmitting) const CircularProgressIndicator(),
                if (!_isSubmitting)
                  ElevatedButton(
                    onPressed: () => _submitContactForm(),
                    child: const Text('Submit'),
                  ),
              ],
            ),
          ),
        )));
  }
}
