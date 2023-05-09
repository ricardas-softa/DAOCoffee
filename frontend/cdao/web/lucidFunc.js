
async function connectWallet () {
  try{
    // console.log("connectWallet");
    const cd =  await import( './lucid-cardano/esm/src/mod.js');
      const lucid = await cd.Lucid.new(
        new cd.Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", "preprodkiIrs2oYlyPSY0nbGKccYS2aSzLpnEbj"),
        "Preprod"
        );
      const api = await window.cardano.nami.enable();
       lucid.selectWallet(api);
       return {"l": lucid};
    }
  catch(e){
    console.log("connectWallet error", e);
    return {"error": `Wallet not found. Please try again. ${e}`};
  }
}

async function readValidator() {
  const cd =  await import( './lucid-cardano/esm/src/mod.js');
  try{
    const response = await fetch("./plutus.json");
      const jResp = await response.json();
      const validator = jResp
      .validators[0];
      return {
          type: "PlutusV2",
          script: validator.compiledCode
      }
    } catch (e) {
     console.log("readValidator error ", e);
     return {"error": `Unable to readValidator. Please try again. ${e}`};
   }
  }

async function purchaseFrontStart(nftId) {
  console.log("nftId", nftId);
  try{
    let cWallet = await connectWallet();
    if(cWallet.error){
      return JSON.stringify(cWallet);
    }else{
      const cd =  await import( './lucid-cardano/esm/src/mod.js');
      const lucid = cWallet.l;
      const mintingPolicy = await readValidator();
      if(mintingPolicy.error){
        console.log("mintingPolicy.error ");
        return JSON.stringify(mintingPolicy);
      }else{
        console.log("mintingPolicyToId ");
        const policyId = lucid.utils.mintingPolicyToId(
          mintingPolicy,
        );

        console.log("policyId + cd.fromText(nftId)");
        // initiate purchase calling end point
        const asset = policyId + cd.fromText(nftId);
        const metadata = {
          [policyId]: {
            [nftId]: {
              name: nftId,
              image: `ipfs://${nftId}`,
            },
          },
        };
        
        console.log("MintAction ");
        const MintAction = () => cd.Data.to(new cd.Constr(0, []));

        console.log("await lucid ");
        const tx = await lucid
          .newTx()
          .addSigner("addr_test1qqfvz5yekvxdn4g0pwgh76u84nz8kc45c62je6mma7gmjgksl4ca3h0xgkj2u5zqr2vx6xksdueffr07juqcswwz4dvqw84ylg")
          .payToAddress("addr_test1qpgr9dcmtd22ku52n698llv7wgh8xj0ayawsqyg9chhd4keshs4u8h3vfn8wz7ecvx8d62h4fjfrhxmxvdcy6jwl090s9d8sty", {lovelace: BigInt(45_000_000)})
          .mintAssets( {[asset]: 1n}, MintAction())
          .validTo(Date.now() + 100000)
          .attachMintingPolicy(mintingPolicy)
          .attachMetadata(721, metadata)
          .complete();
      
        console.log("userWitness ");
        const userWitness = await tx.partialSign();
        console.log("tx", tx.toString());
        console.log("witness", userWitness);
        return `{"tx": "${tx.toString()}", "witness": "${userWitness}"}`;
        //'https://cdao-mint-tm7praakga-uc.a.run.app/mint' http://34.121.45.85:8000/mint
        // fetch('https://cdao-mint-tm7praakga-uc.a.run.app/mint', {
        //   method: 'POST',
        //   headers: {
        //       'Accept': 'application/json',
        //       'Content-Type': 'application/json',
        //       'Access-Control-Allow-Origin': '*',
        //       'Access-Control-Allow-Credentials': 'true',
        //       'Access-Control-Allow-Headers': 'X-Requested-With',
        //       'Access-Control-Allow-Methods': 'GET, POST'
        //   },
        //   body: JSON.stringify({ 
        //     "name": name,
        //     "witness": userWitness,
        //     "tx": tx.toString(),
        //   })
        // }).then(response => {
        //   console.log("response", response);
        //   console.log("JSON.stringify(response)", JSON.stringify(response));
        //   console.log("response body", response.body);
        //   console.log("JSON.stringify(response.body)", JSON.stringify(response.body));
        //   return response.body;
        // })
      }
    }
   } catch (e) {
    console.log("Purchase Front Start error", e);
    return JSON.stringify({"error": `Unable to complete your purchase. Please try again. ${e}`});
  }
}
