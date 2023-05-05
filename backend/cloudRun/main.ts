// import { Application, Router, oakCors } from './deps.ts';
// import { mintNFT } from './mint.ts';
// import { PORT } from "./env.ts";

// const app = new Application();
// // Use the oakCors middleware
// app.use(oakCors());

// const router = new Router();

// // Route for minting an NFT with name and imagePath
// router.post('/mint', async (context) => {
//     const { name, imagePath } = await context.request.body().value;
//     const txHash = await mintNFT(name, imagePath);
//     context.response.body = txHash;
// });



// app.use(router.routes());
// app.use(router.allowedMethods());

// await app.listen({ port: PORT });




// // import { serve } from "https://deno.land/std@0.89.0/http/server.ts";
// // import "https://deno.land/x/dotenv/mod.ts";

// // const PORT = Deno.env.get('PORT') || 8080;
// // const s = serve(`0.0.0.0:${PORT}`);
// // const body = new TextEncoder().encode("Hello, Deno\n");

// // console.log(`Server started on port ${PORT}`);
// // for await (const req of s) {
// //   req.respond({ body });
// // }