import {
          Blockfrost,
          Lucid,
          // MintingPolicy,
          // Unit,
          // PolicyId,
          TxHash,
          // fromHex,
          // toHex,
          // fromText,
          // cbor,
          // Data,
          // Constr,
        } from "./deps.ts";
import { 
  // PINATA_API_KEY, 
  // PINATA_SECRET_KEY, 
  BLOCKFROST_PROJ, MNEMONIC, 
  // DAO_ADDRESS 
} from "./env.ts";

const lucid = await Lucid.new(
  new Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", BLOCKFROST_PROJ),
  "Preprod",
);

// Select the wallet from the mnemonic
const mnemonic = MNEMONIC
lucid.selectWalletFromSeed(mnemonic);

// const mintingPolicy = await readValidator();

// async function readValidator(): Promise<MintingPolicy> {
//   const validator = JSON.parse(await Deno.readTextFile("../plutus.json"))
//       .validators[0];
//   return {
//       type: "PlutusV2",
//       script: toHex(cbor.encode(fromHex(validator.compiledCode)))
//   }
// }

// const policyId: PolicyId = lucid.utils.mintingPolicyToId(
//   mintingPolicy,
// );

export async function mintNFT(
  name: string,
  witness: string,
  tx: string,
): Promise<TxHash> {

  try {
    const mnemonic = MNEMONIC
    lucid.selectWalletFromSeed(mnemonic);
  
    // Deserialize the transaction
    const txObj = lucid.fromTx(tx);
  
    // const daoCoffeeSigningAddress = await lucid.wallet.address();
  
    const daoWitness = await txObj.partialSign();
    const signedTx = txObj.assemble([daoWitness, witness]).complete();
    const txHash = (await signedTx).submit();
    return { "txHash": txHash };
    // lucid.selectWalletFromPrivateKey(await Deno.readTextFile("daoSigning.sk"));

    // const tx =  lucid.fromTx(txstring)
    // const daoSigningWitness = await tx.partialSign();
    // const signedTx = await tx.assemble([wittnes, daoSigningWitness]).complete();
    // const txHash = await signedTx.submit();

    // // Upload the image to Pinata IPFS and get its CID
    // // const imageCID = await uploadImageToPinataIPFS(imagePath);
    // // const imageCID = "QmT1eyranmxTa3EWAePFmpdFWGGDAynqiZZQxnvNLbEt5J";

    // console.log( "hash", txHash );
    // return { "hash": txHash, "url": "test" };
  } catch (error) {
    console.error('Error mintNFT:', error);
    throw error;
  }
}

// async function uploadImageToPinataIPFS(imagePath: string): Promise<string> {
//   try {
//     const data = await Deno.readFile(imagePath);
//     const formData = new FormData();
//     formData.append('file', new Blob([data]), imagePath);

//     const response = await fetch('https://api.pinata.cloud/pinning/pinFileToIPFS', {
//       method: 'POST',
//       body: formData,
//       headers: {
//         pinata_api_key: PINATA_API_KEY,
//         pinata_secret_api_key: PINATA_SECRET_KEY,
//       },
//     });

//     if (!response.ok) {
//       throw new Error(`Error uploading image to Pinata IPFS: ${response.statusText}`);
//     }

//     const responseData = await response.json();
//     return responseData.IpfsHash;
//   } catch (error) {
//     console.error('Error uploading image to Pinata IPFS:', error);
//     throw error;
//   }
// }

// export async function burnNFT(
//   name: string,
// ): Promise<TxHash> {
//   const unit: Unit = policyId + fromText(name);

//   const tx = await lucid
//     .newTx()
//     .mintAssets({ [unit]: -1n })
//     .validTo(Date.now() + 100000)
//     .attachMintingPolicy(mintingPolicy)
//     .complete();

//   const signedTx = await tx.sign().complete();

//   const txHash = await signedTx.submit();

//   return txHash;
// }
