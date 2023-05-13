
# NFT Minting Endpoint (Backend)

## Run the server

```bash
deno run --allow-net --allow-env --allow-read index.ts
```

## Endpoint Details

**URL**: http://localhost:8000/mint

**Method**: POST

**Content-Type**: application/json

**Request Body**:

- `name` (string, required): The name of the NFT.
- `imagePath` (string, required): The local or remote path to the image file to be used as the NFT's artwork.

**Example Request:**

```json
{
  "name": "My NFT",
  "imagePath": "/path/to/image.png"
}
```

## CURL example

```bash
curl -X POST -H "Content-Type: application/json" -d '{"name": "My NFT", "imagePath": "/path/to/image.png"}' http://localhost:8000/mint
```

