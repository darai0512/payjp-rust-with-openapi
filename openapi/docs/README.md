# commands

```
$ uv run jsonnet src/root.yaml -o openapi.json

docker run --rm \
  -v ".:/tmp/" \
  -w "/tmp/" \
  openapitools/openapi-generator-cli generate \
    -g rust \
    -i ./openapi.yaml \
    -o ./dist/client

docker run -p 8080:8080 -e SWAGGER_JSON=/src/openapi.json -v `pwd`/openapi.json:/src swaggerapi/swagger-ui
```

# ボツ

```
"scripts": {
  "build:cli": "openapi-generator-cli generate -i docs/openapi.yaml -g typescript-angular -o dist/ --additional-properties=ngVersion=6.1.7,npmName=restClient,supportsES6=true,npmVersion=6.9.0,withInterfaces=true",
  "schema": "cat ./node_modules/@openapitools/openapi-generator-cli/config.schema.json"
},
"devDependencies": {
  "@openapitools/openapi-generator-cli": "^2.15.0", <- 挙動が不安定
  "jsonnet": "^0.5.0-beta" <- not cli
}
```

```
docker run --rm \
  -v ".:/" \
  -w "/" \
  openapitools/openapi-generator-cli generate \
    -g openapi \
    -i ./root.json \
    -o ./dist
```
