FROM denoland/deno:latest
WORKDIR /app

# These steps will be re-run upon each file change in your working directory:
COPY . ./
EXPOSE 8080 8000
# Added to ENTRYPOINT of base image.
CMD ["run", "--allow-env", "--allow-read", "--allow-net", "index.ts"]
#deno run --allow-env --allow-net index.ts