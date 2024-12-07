# commands

root.jsonnet をビルドして openapi.json を生成する

```
$ docker compose up -d

# if error, check logs
$ docker compose logs -f

# rm all ps
$ docker rm $(docker stop $(docker ps -aq -f name=payjp-rust-*))
```

- jsonnet 内で$refのパス解決のためのrenameをしているが、処理が遅い。簡潔さのためjsonnetを選んだがNode.jsが良さそう
  - gen (=openapi-generator-cli) はvalidation目的で実行しているが、$refのパス解決にも使えなくはない。

※ foreground実行するとshellにコントロールが戻ってこない？ような事象が発生する。未解決。
cf. https://github.com/docker/compose/issues/3347

# ボツmemo

package.json をmake代わりに使い方かったがjsonnetがcliではなかったり微妙だった

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

pyproject.tomlも小回りが効かないのでdockerに統一

```
[project]
name = "payjp-openapi"
version = "0.0.0"
private = true
description = "Just a command runner"
requires-python = ">=3.12"
dependencies = [
    "jsonnet>=0.20.0",
]

[tool.setuptools]
script-files = ["scripts/myscript1", "scripts/myscript2"]
```


```
base.json + {
  "paths": {
    "allOf": [
      {"$ref": "./paths/balance.json#/paths"}
    ]
  },
}
```