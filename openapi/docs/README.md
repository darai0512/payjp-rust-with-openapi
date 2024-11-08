# commands

```
# jsonnet でrootをビルドし
$ uv run jsonnet root.jsonnet -o openapi.json
# openapi-generator-cli で$refのパス読み込みを解決したopenapi.jsonをビルド
$ docker compose up -d
# dist/openapi.jsonが最終生成物。できていなければエラーログを確認
$docker compose logs -f gen
```

# ボツmemo

package.json をmake代わりに使い方かったが微妙だった

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
    -g rust \
    -i ./root.json \
    -o ./dist
```
