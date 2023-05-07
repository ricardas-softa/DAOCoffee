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
          TransactionWitnesses
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

export async function mintNFT(
  name: string,
  witness: TransactionWitnesses,
  tx: string,
): Promise<TxHash> {

  try {
    const mnemonic = MNEMONIC
    lucid.selectWalletFromSeed(mnemonic);
  
    // Deserialize the transaction
    console.log('tx: ', tx);
    console.log('witness: ', witness);
    const txObj = lucid.fromTx(tx);
  
  
    const daoWitness = await txObj.partialSign();
    const signedTx = txObj.assemble([daoWitness, witness]).complete();
    const txHash = (await signedTx).submit();
    return {"txhash": txHash};
  } catch (error) {
    console.error('Error mintNFT:', error);
    return {"error": error };
  }
}

async function uploadImageToPinataIPFS(imagePath: string): Promise<string> {
  try {
    const data = await Deno.readFile(imagePath);
    const formData = new FormData();
    formData.append('file', new Blob([data]), imagePath);

    const response = await fetch('https://api.pinata.cloud/pinning/pinFileToIPFS', {
      method: 'POST',
      body: formData,
      headers: {
        pinata_api_key: PINATA_API_KEY,
        pinata_secret_api_key: PINATA_SECRET_KEY,
      },
    });

    if (!response.ok) {
      throw new Error(`Error uploading image to Pinata IPFS: ${response.statusText}`);
    }

    const responseData = await response.json();
    return responseData.IpfsHash;
  } catch (error) {
    console.error('Error uploading image to Pinata IPFS:', error);
    throw error;
  }
}

export async function burnNFT(
  name: string,
): Promise<TxHash> {
  const unit: Unit = policyId + fromText(name);

  const tx = await lucid
    .newTx()
    .mintAssets({ [unit]: -1n })
    .validTo(Date.now() + 100000)
    .attachMintingPolicy(mintingPolicy)
    .complete();

  const signedTx = await tx.sign().complete();

  const txHash = await signedTx.submit();

  return txHash;
}
