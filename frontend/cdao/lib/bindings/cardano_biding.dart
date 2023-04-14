import 'dart:js';

import 'package:js/js.dart';

// @JS('LucidCarno')
// class LucidCardano{

//   external factory LucidCardano(){

//   }
// }

@JS('window.cardano.nami.enable')
external enable();


@JS('window.lucid.connectWallet')
external connectWallet();