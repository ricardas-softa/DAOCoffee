FROM denoland/deno:latest
WORKDIR /app

# These steps will be re-run upon each file change in your working directory:
COPY . ./

# Added to ENTRYPOINT of base image.
CMD ["run", "--allow-env", "--allow-net", "index.ts"]