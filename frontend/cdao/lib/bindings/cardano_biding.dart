import 'dart:js';
import 'package:js/js.dart';

@JS('window.cardano.nami.enable')
external enable();

@JS('window.lucid.connectWallet')
external connectWallet();