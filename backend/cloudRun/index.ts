import { Application, Router, oakCors } from './deps.ts';
import { mintNFT } from './mint.ts';
import { PORT } from "./env.ts";

const app = new Application();
// Use the oakCors middleware
app.use(oakCors());

const router = new Router();
console.log("starting app");
// Route for minting an NFT with name and imagePath
router.post('/mint', async (context) => {
    const { witness, tx } = await context.request.body().value;
    console.log(`tx: ${tx}`);
    console.log(`witness: ${witness}`);
    const result = await mintNFT(witness, tx);
    context.response.body = result;
});

app.use(router.routes());
app.use(router.allowedMethods());

await app.listen({ port: 8000 });
