import {
          Blockfrost,
          Lucid,
          MintingPolicy,
          Unit,
          PolicyId,
          TxHash,
          fromHex,
          toHex,
          fromText,
          cbor,
        } from "./deps.ts";
import { PINATA_API_KEY, PINATA_SECRET_KEY, BLOCKFROST_PROJ, MNEMONIC } from "./env.ts";

const lucid = await Lucid.new(
  new Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", BLOCKFROST_PROJ),
  "Preprod",
);

// Select the wallet from the mnemonic
const mnemonic = MNEMONIC
lucid.selectWalletFromSeed(mnemonic);

const mintingPolicy = await readValidator();

async function readValidator(): Promise<MintingPolicy> {
  const validator = JSON.parse(await Deno.readTextFile("../plutus.json"))
      .validators[0];
  return {
      type: "PlutusV2",
      script: toHex(cbor.encode(fromHex(validator.compiledCode)))
  }
}

const policyId: PolicyId = lucid.utils.mintingPolicyToId(
  mintingPolicy,
);

export async function mintNFT(
  name: string,
  imagePath: string,
): Promise<TxHash> {
  // Upload the image to Pinata IPFS and get its CID
  // const imageCID = await uploadImageToPinataIPFS(imagePath);
  const imageCID = "QmT1eyranmxTa3EWAePFmpdFWGGDAynqiZZQxnvNLbEt5J";

  const unit: Unit = policyId + fromText(name);
  const metadata = {
    [policyId]: {
      [name]: {
        name: name,
        image: `ipfs://${imageCID}`,
      },
    },
  };

  const tx = await lucid
    .newTx()
    .mintAssets({ [unit]: 1n })
    .validTo(Date.now() + 100000)
    .attachMintingPolicy(mintingPolicy)
    .attachMetadata(721, metadata)
    .complete();

  const partiallySignedTx = await tx.partialSign();

  // return CBOR encoded transaction
  return partiallySignedTx;
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
