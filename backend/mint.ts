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
          Data,
          Constr,
        } from "./deps.ts";
import { PINATA_API_KEY, PINATA_SECRET_KEY, BLOCKFROST_PROJ, MNEMONIC, DAO_ADDRESS } from "./env.ts";

const lucid = await Lucid.new(
  new Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", BLOCKFROST_PROJ),
  "Preprod",
);

// const buyerAddress = "addr_test1qrw3hy6rk6h99mtexatxfxq65hlf60dz7j8ptfp5zek4k0vdeyu5x5erv7ywncrvp9f0gsfwez704frfa8rawruemghslg9y2k";
// lucid.selectWalletFrom({address:buyerAddress})
// const [utxo] = await lucid.wallet.getUtxos();
// console.log(utxo);

// const mintingPolicy = await readValidator();

// console.log(mintingPolicy);

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
  // // Upload the image to Pinata IPFS and get its CID
  // // const imageCID = await uploadImageToPinataIPFS(imagePath);
  // const imageCID = "QmT1eyranmxTa3EWAePFmpdFWGGDAynqiZZQxnvNLbEt5J";

  // const asset: Unit = policyId + fromText(name);

  // const metadata = {
  //   [policyId]: {
  //     [name]: {
  //       name: name,
  //       image: `ipfs://${imageCID}`,
  //     },
  //   },
  // };

  // const MintAction = () => Data.to(new Constr(0, []));

  // const tx = await lucid
  //   .newTx()
  //   .addSigner(daoCoffeeSigningAddress)
  //   // .collectFrom([utxo])
  //   .payToAddress(DAO_ADDRESS, {lovelace: BigInt(45_000_000)})
  //   .payToAddress(buyerAddress, {[asset]: 1n})
  //   .mintAssets( {[asset]: 1n}, MintAction())
  //   .validTo(Date.now() + 100000)
  //   .attachMintingPolicy(mintingPolicy)
  //   .attachMetadata(721, metadata)
  //   .complete();

  // const userWitness = await tx.partialSign();

  // Select the wallet from the mnemonic
  const mnemonic = MNEMONIC
  lucid.selectWalletFromSeed(mnemonic);

  // Deserialize the transaction
  const txObj = lucid.fromTx(tx);

  const daoCoffeeSigningAddress = await lucid.wallet.address();

  const daoWitness = await txObj.partialSign();
  const signedTx = txObj.assemble([daoWitness, witness]).complete();
  const txHash = (await signedTx).submit();
  return { "txHash": txHash };
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
