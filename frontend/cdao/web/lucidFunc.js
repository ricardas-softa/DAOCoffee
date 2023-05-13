
async function connectWallet () {
  try{
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
        const policyId = lucid.utils.mintingPolicyToId(
          mintingPolicy,
        );
        const asset = policyId + cd.fromText(nftId.substr(0, 31));
        const metadata = {
          [policyId]: {
            [nftId.substr(0, 31)]: {
              name: nftId.substr(0, 31),
              image: `ipfs://${nftId}`,
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
        return `{"tx": "${tx.toString()}", "witness": "${userWitness}"}`;
      }
    }
   } catch (e) {
    console.log("Purchase Front Start error", e);
    return JSON.stringify({"error": `Unable to complete your purchase. Please try again. ${e}`});
  }
}
