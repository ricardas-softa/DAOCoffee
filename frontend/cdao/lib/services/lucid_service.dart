import 'dart:js' as js;

import '../bindings/cardano_biding.dart';


class LucidService {
  static const _lucid = 'lucid'; // JavaScript global variable name for Lucid

  // static Future<js.JsObject> _getLucid() async {
  //   // Get the global Lucid object
  //   return js.context.callMethod('eval', ['window.$_lucid']);
  // }

  static Future<void> connectNamiWallet() async {
  final api =  await enable();
  

    // final a = await api.enable();
    // print(a);
// Assumes you are in a browser environment
    // final ch = chkEn();

    // print(ch.apiVersion);

    // final api = await js.context.callMethod('window.cardano.nami.enable');
    // final lucid = await _getLucid();
    // lucid.callMethod('selectWallet', [api]);
    //   lucid.callMethod(
    //       'setNetwork', ['preprod']); // or 'testnet' for Cardano testnet
    //
    //
  }

  // static Future<String> sendTransaction(
  //     String receiverAddress, int amount) async {
  //   final lucid = await _getLucid();

  //   // Build transaction
  //   final tx = lucid.callMethod('newTx');
  //   tx.callMethod('payToAddress', [
  //     receiverAddress,
  //     {'lovelace': amount}
  //   ]);

  //   // Sign and submit transaction
  //   final signedTx = await tx.callMethod('sign');
  //   final txHash = await signedTx.callMethod('submit');

  //   return txHash;
  // }
}
