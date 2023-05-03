async function connectWallet () {
  try{
    console.log("connectWallet");
    const cd =  await import( './lucid-cardano/esm/src/mod.js');
    const lucid = await cd.Lucid.new(
      new cd.Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", "preprodkiIrs2oYlyPSY0nbGKccYS2aSzLpnEbj"),
      "Preprod"
    );
    const api = await window.cardano.nami.enable();
       lucid.selectWallet(api);
    //   return {"l": lucid, "a": api};
       return {"l": lucid};
    }
    catch(e){
     console.log("connectWallet "+e);
     return "Wallet not found";
    }
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

  // const tx = await lucid.newTx()
  //   .collectFrom([scriptUtxo])
  //   .payToAddress("addr..", {lovelace: 50000000n})
  //   .attachSpendingValidator(multisigScript)
  //   .complete();
  // const signedTx = await tx.assemble(["<sig_1>", "<sig_2>"]).complete();
  // const txHash = await signedTx.submit();
  
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
  return txHash;
}

    
async function purchaseFrontStart() {
  try{
    console.log("purchaseFrontStart");
    let cWallet = await connectWallet();
    if(cWallet=="Wallet not found"){
      return cWallet;
    }else{
      console.log("Wallet ", cWallet);
      const lucid = cWallet.l;
      const cd =  await import( './lucid-cardano/esm/src/mod.js');

      // initiate purchase calling end point
      
      
      // result partial sign and return to complete end point

      // display some result

      const MintRedeemer = () => Data.to(new Constr(0, []))
      const BurnRedeemer = () => Data.to(new Constr(1, []))

      const utxos = await Uint8ClampedArray.wallet.getUtxos();
      if (utxos.length == 0) {
        return "No UTXOs Available"
      }
      // const txId = new Constr (0, [utxos[0].txHash])
      // const txIdx = new BigInt(utxos[0].outputIndex)
      // const txOutRef = new Constr (0, [txId, txIdx])

      const daoAddrPreProd ="";
      // const daoAddrMain ="";
      const daoPKH = paymentCredentialOf(daoAddrPreProd).hash
      const mintingPolicy = {
        type: "PlutusV2",
        script: applyParamssToScript(coffeeCbor, [daoPKH]), //TODO: backend sign? 
      };
      const policyId = lucid.utils.mintingPolicyToId(mintingPolicy);
      const mintIdx = 0;
      const tokenName = fromText("CoffeeDAO Number xxxx") // TODO: pass the curent NFT count to function.
      const assetToMint = policyId + tokenName;
      
      
      const tx = await lucid
      .newTx()
      .mintAssets({ [assetToMint]: BigInt(1) }, MintRedeemer())
      .payToAddress(daoAddrPreProd, {lovelace: BigInt(45_000_000)})
      .attachMintingPolicy(mintingPolicy)
      .addSignerKey(daoPKH) //TODO: backend sign?
      .complete();

      console.log("tx: ", tx);

      const signedTx = await tx.sign().complete();
      console.log("signedTx: ", signedTx);

      const txHash = await signedTx.submit();
      console.log("txHash: ", txHash);
      return txHash.toString();
    }
   } catch (e) {
    console.log("Purchase Front Start "+e);
    return "Unable to connect to wallet";}
}

// TODO: add quantity/ comms dart to js
async function purchaseBackStart() {
  try{
    console.log("purchaseBackStart");
    let cWallet = await connectWallet();
    if(cWallet=="Wallet not found"){
    return cWallet;
    }else{
    console.log("Wallet ", cWallet);
    
    // initiate purchase calling end point
    // var partialTx = await post/endpoint

    // result partial sign and return to complete end point
    const userWitness = await partialTx.transaction.partialSign();
    return {
      "witness": witness,
      "userWitness": userWitness,
      "partialTx": partialTx
    };


    const signedTx = partialTx.transaction.assemble([userWitness, partialTx.witness]).complete();
    const txHash = signedTx.submit();
    console.log("tx: ", tx);

    console.log("txHash: ", txHash);
    return txHash.toString();
    }
   } catch (e) {
    console.log("Purchase Back Start "+e);
    return "Unable to connect to wallet";}
}
    
    // export { purchaseBackStart };
  