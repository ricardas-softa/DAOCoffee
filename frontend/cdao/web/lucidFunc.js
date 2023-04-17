async function connectWallet () {
  console.log("connectWallet");
  const cd =  await import( './lucid-cardano/esm/src/mod.js');

  const lucid = await cd.Lucid.new(
    new cd.Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", "preprodkiIrs2oYlyPSY0nbGKccYS2aSzLpnEbj"),
    "Preprod"
  );
    
  console.log(lucid);
    const api = await window.cardano.nami.enable();
  // Assumes you are in a browser environment
      
  lucid.selectWallet(api);
  return {"l": lucid, "a": api};
}
 
 async function alwaysSucceed () {
  console.log("alwaysSucceed");
  let cWallet = await connectWallet();
  const lucid = cWallet.l;
  const api = cWallet.a;

  const cd =  await import( './lucid-cardano/esm/src/mod.js');
  
  const alwaysSucceedScript = {
    type: "PlutusV2",
    script: "49480100002221200101",
  };
  const alwaysSucceedAddress = lucid.utils.validatorToAddress(
    alwaysSucceedScript
  );
  
  const Datum = () => cd.Data.void();

  const tx = await lucid
  .newTx()
  .payToContract(alwaysSucceedAddress, { inline: Datum() }, {lovelace: 40000000n})
  .payToContract(alwaysSucceedAddress, {
    asHash: Datum(),
    scriptRef: alwaysSucceedScript, // adding plutusV2 script to output
  }, {})
  .complete();
  console.log("tx: ", tx);

  const signedTx = await tx.sign().complete();
  console.log("signedTx: ", signedTx);

  const txHash = await signedTx.submit();
  console.log("txHash: ", txHash);
}

    
  //   async function redeemUtxo() {
        // console.log("redeemUtxo");
        // let cWallet = await connectWallet();
        // const lucid = cWallet.l;
        // const api = cWallet.a;

        // const cd =  await import( './lucid-cardano/esm/src/mod.js');
  //     const referenceScriptUtxo = (await lucid.utxosAt(alwaysSucceedAddress)).find(
  //       (utxo) => Boolean(utxo.scriptRef)
  //     );
  //     if (!referenceScriptUtxo) throw new Error("Reference script not found");
    
  //     const utxo = (await lucid.utxosAt(alwaysSucceedAddress)).find(
  //       (utxo) => utxo.datum === Datum() && !utxo.scriptRef
  //     );
  //     if (!utxo) throw new Error("Spending script utxo not found");
    
  //     const tx = await lucid
  //       .newTx()
  //       .readFrom([referenceScriptUtxo]) // spending utxo by reading plutusV2 from reference utxo
  //       .collectFrom([utxo], Redeemer())
  //       .complete();
    
  //     const signedTx = await tx.sign().complete();
    
  //     const txHash = await signedTx.submit();
    
  //     return txHash;
  //   }
    
  //   // export { lockUtxo, redeemUtxo };
    
  // }
  