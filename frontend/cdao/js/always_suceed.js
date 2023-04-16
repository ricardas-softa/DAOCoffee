import {
    Address,
    Blockfrost,
    Data,
    Lovelace,
    Lucid,
    SpendingValidator,
    TxHash,
  } from "../../mod.js";
  
  /*
    AlwaysSucceeds Example
    Lock a UTxO with some ADA
    UTxO can be unlocked by anyone
    Showcasing PlutusV2
    Contract:
    validate :: () -> () -> ScriptContext -> Bool
    validate _ _ _ = True
  */
  
  const lucid = await Lucid.new(
    new Blockfrost("https://cardano-preview.blockfrost.io/api/v0", "preprodDCAbR2aBq5Od7CNzTtApdSKrS04CYUM9"),
    "Preprod"
  );
  
  const api = await window.cardano.nami.enable().then();
  // Assumes you are in a browser environment
  lucid.selectWallet(api);
  
  const alwaysSucceedScript = {
    type: "PlutusV2",
    script: "49480100002221200101",
  };
  
  const alwaysSucceedAddress = lucid.utils.validatorToAddress(
    alwaysSucceedScript
  );
  
  const Datum = () => Data.void();
  const Redeemer = () => Data.void();
  
  async function lockUtxo(lovelace) {
    const tx = await lucid
      .newTx()
      .payToContract(alwaysSucceedAddress, { inline: Datum() }, { lovelace })
      .payToContract(alwaysSucceedAddress, {
        asHash: Datum(),
        scriptRef: alwaysSucceedScript, // adding plutusV2 script to output
      }, {})
      .complete();
  
    const signedTx = await tx.sign().complete();
  
    const txHash = await signedTx.submit();
  
    return txHash;
  }
  
  async function redeemUtxo() {
    const referenceScriptUtxo = (await lucid.utxosAt(alwaysSucceedAddress)).find(
      (utxo) => Boolean(utxo.scriptRef)
    );
    if (!referenceScriptUtxo) throw new Error("Reference script not found");
  
    const utxo = (await lucid.utxosAt(alwaysSucceedAddress)).find(
      (utxo) => utxo.datum === Datum() && !utxo.scriptRef
    );
    if (!utxo) throw new Error("Spending script utxo not found");
  
    const tx = await lucid
      .newTx()
      .readFrom([referenceScriptUtxo]) // spending utxo by reading plutusV2 from reference utxo
      .collectFrom([utxo], Redeemer())
      .complete();
  
    const signedTx = await tx.sign().complete();
  
    const txHash = await signedTx.submit();
  
    return txHash;
  }
  
  export { lockUtxo, redeemUtxo };
  