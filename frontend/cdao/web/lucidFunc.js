
async function connectWallet () {
  try{
    console.log("connectWallet");
    const cd =  await import( './lucid-cardano/esm/src/mod.js');
    console.log("0");
      const lucid = await cd.Lucid.new(
        new cd.Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", "preprodkiIrs2oYlyPSY0nbGKccYS2aSzLpnEbj"),
        "Preprod"
        );
  
      console.log("1");
      const api = await window.cardano.nami.enable();
       console.log("2");
    // Assumes you are in a browser environment
    //     console.log(api.toString()+"Apiiii");
       lucid.selectWallet(api);
            console.log("3");
    //   return {"l": lucid, "a": api};
       return {"l": lucid};
    }
  catch(e){
    console.log("connectWallet "+e);
    return "Nami wallet not found";
  }
}

async function readValidator() {
  const cd =  await import( './lucid-cardano/esm/src/mod.js');
  try{
    const response = await fetch("./plutus.json");
      const jResp = await response.json();
      console.log("jResp", jResp);
      const validator = jResp
      .validators[0];
      console.log("validator.compiledCode", validator.compiledCode);
      return {
          type: "PlutusV2",
          script: validator.compiledCode //cd.toHex(cbw.cbor.encode(cd.fromHex(validator.compiledCode)))
      }
    } catch (e) {
     console.log("readValidator error ", e);
     return "Unable to readValidator";
   }
  }

async function purchaseFrontStart() {
  try{
    console.log("purchaseFrontStart");
    let cWallet = await connectWallet();
    if(cWallet=="Wallet not found"){
      return cWallet;
    }else{
      const cd =  await import( './lucid-cardano/esm/src/mod.js');
      console.log("Wallet ", cWallet);
      const lucid = cWallet.l;
      console.log("await readValidator()");
      const mintingPolicy = await readValidator();
      console.log("mintingPolicyToId()", mintingPolicy);
      const policyId = lucid.utils.mintingPolicyToId(
        mintingPolicy,
      );

      // initiate purchase calling end point
      console.log("initiate purchase calling end point");
      const imageCID = "QmT1eyranmxTa3EWAePFmpdFWGGDAynqiZZQxnvNLbEt5J";
      const name = "AG21";
      const asset = policyId + cd.fromText(name);
    
      const metadata = {
        [policyId]: {
          [name]: {
            name: name,
            image: `ipfs://${imageCID}`,
          },
        },
      };
    
      // const userSigningAddress = await lucid.wallet.address();
    
      const MintAction = () => cd.Data.to(new cd.Constr(0, []));
    
      const tx = await lucid
        .newTx()
        .addSigner("addr_test1qqfvz5yekvxdn4g0pwgh76u84nz8kc45c62je6mma7gmjgksl4ca3h0xgkj2u5zqr2vx6xksdueffr07juqcswwz4dvqw84ylg")
        .payToAddress("addr_test1qpgr9dcmtd22ku52n698llv7wgh8xj0ayawsqyg9chhd4keshs4u8h3vfn8wz7ecvx8d62h4fjfrhxmxvdcy6jwl090s9d8sty", {lovelace: BigInt(45_000_000)})
        .mintAssets( {[asset]: 1n}, MintAction())
        .validTo(Date.now() + 100000)
        .attachMintingPolicy(mintingPolicy)
        .attachMetadata(721, metadata)
        .complete();
    
      const userWitness = await tx.partialSign();
      
      fetch('http://localhost:8000/mint', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Allow-Headers': 'X-Requested-With',
            'Access-Control-Allow-Methods': 'GET, POST'
        },
        body: JSON.stringify({ 
          "name": "AG21",
          "witness": userWitness, // .toString(), //  "witness": toHex(userWitness.to_bytes()),
          "tx": tx.toString(),
        })
      }).then(response => console.log(JSON.stringify(response)))
    }
   } catch (e) {
    console.log("Purchase Front Start ", e);
    return "Unable to connect to wallet";
  }
}

// TODO: add quantity/ comms dart to js
// async function purchaseBackStart() {
//   try{
//     console.log("purchaseBackStart");
//     let cWallet = await connectWallet();
//     if(cWallet=="Wallet not found"){
//     return cWallet;
//     }else{
//     console.log("Wallet ", cWallet);
    
//     // initiate purchase calling end point
//     // var partialTx = await post/endpoint

//     // result partial sign and return to complete end point
//     const userWitness = await partialTx.transaction.partialSign();
//     return {
//       "witness": witness,
//       "userWitness": userWitness,
//       "partialTx": partialTx
//     };


//     const signedTx = partialTx.transaction.assemble([userWitness, partialTx.witness]).complete();
//     const txHash = signedTx.submit();
//     console.log("tx: ", tx);

//     console.log("txHash: ", txHash);
//     return txHash.toString();
//     }
//    } catch (e) {
//     console.log("Purchase Back Start "+e);
//     return "Unable to connect to wallet";}
// } 
// async function alwaysSucceed () {
//  console.log("alwaysSucceed");
//  let cWallet = await connectWallet();
//  const lucid = cWallet.l;
//  const api = cWallet.a;

//  const cd =  await import( './lucid-cardano/esm/src/mod.js');import cbor from 'cbor-web'
 
//  const alwaysSucceedScript = {
//    type: "PlutusV2",
//    script: "49480100002221200101",
//  };
//  const alwaysSucceedAddress = lucid.utils.validatorToAddress(
//    alwaysSucceedScript
//  );

//  // const tx = await lucid.newTx()
//  //   .collectFrom([scriptUtxo])
//  //   .payToAddress("addr..", {lovelace: 50000000n})
//  //   .attachSpendingValidator(multisigScript)
//  //   .complete();
//  // const signedTx = await tx.assemble(["<sig_1>", "<sig_2>"]).complete();
//  // const txHash = await signedTx.submit();
 
//  const Datum = () => cd.Data.void();

//  const tx = await lucid
//  .newTx()
//  .payToContract(alwaysSucceedAddress, { inline: Datum() }, {lovelace: 40000000n})
//  .payToContract(alwaysSucceedAddress, {
//    asHash: Datum(),
//    scriptRef: alwaysSucceedScript, // adding plutusV2 script to output
//  }, {})
//  .complete();
//  console.log("tx: ", tx);

//  const signedTx = await tx.sign().complete();
//  console.log("signedTx: ", signedTx);

//  const txHash = await signedTx.submit();
//  console.log("txHash: ", txHash);
//  return txHash;
// }