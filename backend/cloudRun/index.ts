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
    const { name, wittnes, tx } = await context.request.body().value;
    context.response.body = await mintNFT(name, wittnes, tx);
});

app.use(router.routes());
app.use(router.allowedMethods());

await app.listen({ port: PORT });

// Run the server with:
// deno run --allow-net --allow-env --allow-read index.ts

// To test the server, run:
// curl -X POST -H "Content-Type: application/json" -d '{"name": "My NFT", "imagePath": "/path/to/image.png"}' http://localhost:8000/mint


