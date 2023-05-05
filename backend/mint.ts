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
          TransactionWitnesses,
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
  witness: TransactionWitnesses,
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

  // const txTest = "84ab00818258201f7b737b4734252de2d992ad54b99620e113fd96b3f7aa1ba16b9a3d49117d6b020183825839005032b71b5b54ab728a9e8a7ffd9e722e7349fd275d001105c5eedadb30bc2bc3de2c4ccee17b38618edd2af54c923b9b6663704d49df795f1a02aea540825839005f67c6cd1791f53516fc2e8ba28f97ecbfe73173eda070a48957e9b6aeeb8d660b576a621ed7ce376ab4d94c37693a9c82ee2f430fd0b122821a00115cb0a1581cbbc78257b99341d2bbfe21684d073d465e49765f989c3907659d2c04a1444147323101825839005f67c6cd1791f53516fc2e8ba28f97ecbfe73173eda070a48957e9b6aeeb8d660b576a621ed7ce376ab4d94c37693a9c82ee2f430fd0b1221b000000024e83ac26021a000419fd031a01a5b42d075820848d1eb0a29bc1e1cb41422ec4dc39de1ac0f87a1f097afb8d9f6848972043ef09a1581cbbc78257b99341d2bbfe21684d073d465e49765f989c3907659d2c04a14441473231010b58205d6de2a317473c95ff6efa6ce6a1cc3f35ef959e4cb2bd8e602c518a289896f20d818258201f7b737b4734252de2d992ad54b99620e113fd96b3f7aa1ba16b9a3d49117d6b020e81581c12c15099b30cd9d50f0b917f6b87acc47b62b4c6952ceb7bef91b92210825839005f67c6cd1791f53516fc2e8ba28f97ecbfe73173eda070a48957e9b6aeeb8d660b576a621ed7ce376ab4d94c37693a9c82ee2f430fd0b1221b000000025141a117111a000626fca20581840100d87980821a00035ffd1a04c92a4e06815904d65904d30100003232323232323232323232323222325333008323232323232323232325333017301a00213232323253330163370e900000089919299980c299980c299980c19911919299980e19b87480080044c8c8cdc48008029bad3024001301a00214a060340026602c60306602c603000490012400066028602c01e900724101c14fcd6ac4266e1c009208095f52a14a0200229404cdc3802240042940ccc8c0040048894ccc07c00852809919299980e19b8f00200314a2266600a00a00200660460066eb8c084008dd619809980a8072402091011c12c15099b30cd9d50f0b917f6b87acc47b62b4c6952ceb7bef91b922003232333323001001222253330210031001132323300400233330060060010040033025004302300300122337006646464644646464a66604466e1d20020011480004c8dd698150009810001181000099299981099b8748008004530103d87a800013232330060014890037566052002603e004603e00266008002911003001001222533302400214c103d87a800013232323253330233371e00a002266e95200033029375000497ae01333007007003005375c604a0066eb4c094008c0a000cc098008c0040048894ccc088008530103d87a800013232323253330213371e00a002266e95200033027374c00497ae01333007007003005375c60460066eacc08c008c09800cc090008dd59980b180c00124004002900019991800800911299980f8010a5eb804c8c94ccc070c00c0084cc088008ccc01401400400c4ccc01401400400cc08c00cc0840080048c8c8cdc7800a4411c5032b71b5b54ab728a9e8a7ffd9e722e7349fd275d001105c5eedadb00375c6040002602c64a66603266e1d200030180011001153301b4912a4578706563746564206f6e20696e636f727265637420636f6e7374727563746f722076617269616e742e0016330143016330143016001480012000375866024602801a9002099b8700233702900024004602801c6eb4c06c004c06c004c06800454cc0512401334c6973742f5475706c652f436f6e73747220636f6e7461696e73206d6f7265206974656d73207468616e206578706563746564001637586030002664646464466600800244466600a004444a66603666e1c00920001001133021374e660426ea4018cc084dd4801998109ba80024bd70000800a5eb80c00400488894ccc06c00c40044c8c8c8c8ccc018004008cccc02002000c018014dd7180e0019bad301c002301f004301d00330010012222533301900310011323232323330060010023333008008003006005375c60340066eacc068008c074010c06c00c004dd5980b000980b000980a800980a00098098009804000980800098030010a4c2c6601064a66601066e1d20000011533300d3006003149854cc0292411d4578706563746564206e6f206669656c647320666f7220436f6e7374720016153330083370e90010008a99980698030018a4c2a6601492011d4578706563746564206e6f206669656c647320666f7220436f6e7374720016153300a4912b436f6e73747220696e64657820646964206e6f74206d6174636820616e7920747970652076617269616e740016300600200233001001480008888cccc01ccdc38008018071199980280299b8000448008c0400040080088c01cdd5000918029baa0015734ae6d5ce2ab9d5573caae7d5d02ba15745f5a11902d1a178386262633738323537623939333431643262626665323136383464303733643436356534393736356639383963333930373635396432633034a16441473231a265696d6167657835697066733a2f2f516d5431657972616e6d785461334557416550466d7064465747474441796e71695a5a51786e764e4c624574354a646e616d656441473231"
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
