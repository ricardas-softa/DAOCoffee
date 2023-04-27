import { Application, Router, oakCors } from './deps.ts';
import { mintNFT } from './mint.ts';
import { PORT } from "./env.ts";

const app = new Application();
// Use the oakCors middleware
app.use(oakCors());

const router = new Router();

// Route for minting an NFT with name and imagePath
router.post('/mint', async (context) => {
    const { name, imagePath } = await context.request.body().value;
    const txHash = await mintNFT(name, imagePath);
    context.response.body = txHash;
});



app.use(router.routes());
app.use(router.allowedMethods());

await app.listen({ port: PORT });

// Run the server with:
// deno run --allow-net --allow-env --allow-read index.ts

// To test the server, run:
// curl -X POST -H "Content-Type: application/json" -d '{"name": "My NFT", "imagePath": "/path/to/image.png"}' http://localhost:8000/mint


