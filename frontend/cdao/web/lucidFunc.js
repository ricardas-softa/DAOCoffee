
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
          script: validator.compiledCode
      }
    } catch (e) {
     console.log("readValidator error ", e);
     return "Unable to readValidator";
   }
  }

async function purchaseFrontStart() {
  try{
    let cWallet = await connectWallet();
    if(cWallet=="Wallet not found"){
      return cWallet;
    }else{
      const cd =  await import( './lucid-cardano/esm/src/mod.js');
      const lucid = cWallet.l;
      const mintingPolicy = await readValidator();
      const policyId = lucid.utils.mintingPolicyToId(
        mintingPolicy,
      );

      // initiate purchase calling end point
      const imageCID = "QmT1eyranmxTa3EWAePFmpdFWGGDAynqiZZQxnvNLbEt5J";
      const name = "NWO30";
      const asset = policyId + cd.fromText(name);
    
      const metadata = {
        [policyId]: {
          [name]: {
            name: name,
            image: `ipfs://${imageCID}`,
          },
        },
      };
        
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
      fetch('https://cdao-mint-tm7praakga-uc.a.run.app/mint', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': 'https://cdao-mint-tm7praakga-uc.a.run.app',
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Allow-Headers': 'X-Requested-With',
            'Access-Control-Allow-Methods': 'GET, POST'
        },
        body: JSON.stringify({ 
          "name": "AG21",
          "witness": userWitness,
          "tx": tx.toString(),
        })
      }).then(response => {
        console.log("response", response, JSON.stringify(response));
        return {"response": response, "url": `ipfs://${imageCID}`};
      })
    }
   } catch (e) {
    console.log("Purchase Front Start ", e);
    return {"error": `Unable to completee your purchase. Please try again. ${e}`};
  }
}
