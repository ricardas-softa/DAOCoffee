/* eslint-disable max-len */
import * as functions from "firebase-functions";
import {Blockfrost, Lucid} from "lucid-cardano";

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const mint = functions.https.onRequest(async (request, response) => {
  try {
    const mnemonic = "foil bike garbage blame drama bless unknown limit upset abandon brand song humble relax ethics gate render immense gun favorite resist pupil awkward whale";
    const lucid = await Lucid.new(
        new Blockfrost("https://cardano-preprod.blockfrost.io/api/v0", "preprodkiIrs2oYlyPSY0nbGKccYS2aSzLpnEbj"),
        "Preprod",
    );
    lucid.selectWalletFromSeed(mnemonic);
    // Deserialize the transaction
    console.log("tx: ", request.params.tx);
    console.log("witness: ", request.params.witness);
    const txObj = lucid.fromTx(request.params.tx);
    const daoWitness = await txObj.partialSign();
    const signedTx = txObj.assemble([daoWitness, request.params.witness]).complete();
    const txHash = await (await signedTx).submit();
    response.status(200).send({"txHash": txHash});
  } catch (error) {
    console.error("Error mintNFT:", error);
    throw error;
  }
  response.send("Hello from Firebase!");
});
