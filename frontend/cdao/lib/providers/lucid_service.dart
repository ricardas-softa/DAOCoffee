import 'dart:js' as js;
import '../bindings/cardano_biding.dart';

class LucidService {
  static connectNamiWallet() async {
    js.context.callMethod('alwaysSucceed');
  }
}
