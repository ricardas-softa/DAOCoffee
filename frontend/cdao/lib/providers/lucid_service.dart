import 'dart:js' as js;
import '../bindings/cardano_biding.dart';

class LucidService {
  static connectNamiWallet() {
    js.context.callMethod('alwaysSucceed');
  }
}