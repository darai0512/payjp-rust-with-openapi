{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP Charge API specification in OpenAPI 3.0"
  },
  "paths": {
    "/charges": {
      "post": {
        "summary": "支払いを作成",
        "description": "トークンIDまたはカードを保有している顧客IDを指定して支払いを作成します。\nなお、以前はカードオブジェクトの指定ができましたが非通過対応により既に当該パラメーターは利用出来ないようになっております。\n詳しくは [カード情報非通過化対応のお願い](https://pay.jp/info/2017/11/10/182738) をご覧ください。\n\nテスト用のキーでは、本番用の決済ネットワークへは接続されず、実際の請求が行われることもありません。\n本番用のキーでは、決済ネットワークで処理が行われ、実際の請求が行われます。\n\n支払いを確定せずに、カードの認証と支払い額のみ確保する場合は、 `capture` に `false` を指定してください。\nこのとき `expiry_days` を指定することで、認証の期間を定めることができます。 `expiry_days` はデフォルトで7日となっており、1日~60日の間で設定が可能です。なお60日に設定した場合、認証期限は59日後の11:59PM(日本時間)までになります。また確保されました与信枠は、`expiry_days` で設定されました期間を過ぎると解放されるようなっております。\n\n`three_d_secure` にtrueを指定することで、3Dセキュアを開始できます。\n指定した場合、支払いオブジェクトは作成されますが実際の決済処理は保留された状態になります。\n保留中の支払いは、引数指定の内容に関わらず`captured`は`false`、`captured_at`は`null`、`expired_at`は`null`と表示されます。\nなお、支払い作成から30分を経過すると、3Dセキュアフローはタイムアウトし、処理が進められなくなります。\n3Dセキュアの進め方は、 [支払いで3Dセキュアを実施する](https://pay.jp/docs/charge-tds) を参照してください。",
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/chargeCreateRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "作成されたchargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      },
      "get": {
        "summary": "支払いリストを取得",
        "description": "生成した支払い情報のリストを取得します。",
        "parameters": [
          {
            "name": "limit",
            "in": "query",
            "description": "取得するデータ数の最大値(1~100まで)。指定がない場合は 10 となる。",
            "schema": {
              "type": "integer",
              "default": 10,
              "minimum": 1,
              "maximum": 100
            }
          },
          {
            "name": "offset",
            "in": "query",
            "description": "基準点からのデータ取得を行う開始位置。指定がない場合は 0 となる。",
            "schema": {
              "type": "integer",
              "default": 0,
              "minimum": 0
            }
          },
          {
            "name": "since",
            "in": "query",
            "description": "指定したタイムスタンプ以降に作成されたデータのみ取得",
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          },
          {
            "name": "until",
            "in": "query",
            "description": "指定したタイムスタンプ以前に作成されたデータのみ取得",
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          },
          {
            "name": "customer",
            "in": "query",
            "description": "絞り込みたい顧客ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "subscription",
            "in": "query",
            "description": "絞り込みたい定期課金ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "tenant",
            "in": "query",
            "description": "[PAY.JP Platform](#platform-api)のみ指定可能\n\n絞り込みたいテナントID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "term",
            "in": "query",
            "description": "[入金管理オブジェクトの刷新に伴い、2024/06/01以降に提供されます。](https://pay.jp/docs/migrate-transfer)\n\n絞り込みたいTermのID",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "chargeオブジェクトのlistオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/chargeList"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      }
    },
    "/charges/{id}": {
      "get": {
        "summary": "支払い情報を取得",
        "description": "生成された支払い情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "支払いID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ch_fa990a4c10672a93053a774730b0a"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したidのchargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "支払い情報を更新",
        "description": "支払い情報を更新します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "支払いID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ch_fa990a4c10672a93053a774730b0a"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/chargeUpdateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "更新されたchargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      }
    },
    "/charges/{id}/tds_finish": {
      "post": {
        "summary": "3Dセキュアフローを完了する",
        "description": "3Dセキュア認証が終了した支払いに対し、決済を行います。\n[支払いを作成](#支払いを作成) と同様の決済処理が実行され、実際の請求が行われる状態になります。カードの状態によっては支払いに失敗し、402エラーとなる点も同様です。\n保留中の支払いで固定値となっていた`capture`、`captured_at`、`expired_at`は、支払い作成時に指定した通りに反映されます。`captured_at`、`expired_at`の時刻は本APIにリクエストした時刻を基準として設定されます。\n\n`three_d_secure_status`が`verified`、`attempted`でない支払いに対して本APIをリクエストした場合、エラーとなります。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "支払いID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ch_fa990a4c10672a93053a774730b0a"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "chargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      }
    },
    "/charges/{id}/refund": {
      "post": {
        "summary": "返金する",
        "description": "支払い済みとなった処理を返金します。全額返金、及び `amount` を指定することで金額の部分返金を行うことができます。また確定していない支払いも取り消すことができますが `amount` を指定して部分返金をすることはできません。\n\nなお返金可能な期限につきましては売上作成より`180日以内`となります。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "支払いID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ch_fa990a4c10672a93053a774730b0a"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/chargeRefundRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "返金後の状態のchargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      }
    },
    "/charges/{id}/reauth": {
      "post": {
        "summary": "支払いを再認証する",
        "description": "**各種SDKは順次対応予定です**\n\n認証状態となった処理待ちの支払いを再認証します。 `captured=\"false\"` の支払いが対象です。\n`expiry_days` を指定することで、新たな認証の期間を定めることができます。 `expiry_days` はデフォルトで7日となっており、1日~60日の間で設定が可能です。なお60日に設定した場合、認証期限は59日後の11:59PM(日本時間)までになります。\n\n**再認証が必要な場合は認証状態の charge を[返金し](#返金する)、新たに[支払いを作成](#支払いを作成) することを推奨いたします。**\n\nこのAPIは認証済みの与信をキャンセルせず別の与信を作るため、同じ金額で認証済みでも失敗したり、デビットカードなどでは一度目の認証(capture=falseの支払い)と含めて二重に金額が引き落とされることがあります。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "支払いID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ch_fa990a4c10672a93053a774730b0a"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/chargeReauthRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "再認証後の状態のchargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      }
    },
    "/charges/{id}/capture": {
      "post": {
        "summary": "支払い処理を確定する",
        "description": "認証状態となった処理待ちの支払い処理を確定させます。具体的には `captured=\"false\"` となった支払いが該当します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "支払いID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ch_cce2fce62e9cb5632b3d38b0b1621"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/chargeCaptureRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "支払いが確定された状態のchargeオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/charge"
                }
              }
            }
          },
          "4XX": {
            "description": "エラーレスポンス",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/error"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "charge": {
        "type": "object",
        "description": "chargeオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "ch_で始まる一意なオブジェクトを示す文字列",
            "example": "ch_fa990a4c10672a93053a774730b0a"
          },
          "object": {
            "type": "string",
            "description": "\"charge\"の固定文字列",
            "example": "charge"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "この支払い作成時のUTCタイムスタンプ"
          },
          "amount": {
            "type": "integer",
            "description": "支払い額"
          },
          "currency": {
            "type": "string",
            "description": "3文字のISOコード(現状 \"jpy\" のみサポート)",
            "example": "jpy"
          },
          "paid": {
            "type": "boolean",
            "description": "認証処理が成功しているかどうか。"
          },
          "expired_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "認証状態が自動的に失効される日時のタイムスタンプ"
          },
          "captured": {
            "type": "boolean",
            "description": "支払い処理を確定しているかどうか"
          },
          "captured_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "支払い処理確定時のUTCタイムスタンプ"
          },
          "card": {
            "$ref": "#/components/schemas/card"
          },
          "customer": {
            "type": ["string", "null"],
            "description": "顧客ID"
          },
          "description": {
            "type": ["string", "null"],
            "description": "概要"
          },
          "failure_code": {
            "type": ["string", "null"],
            "description": "失敗した支払いのエラーコード"
          },
          "failure_message": {
            "type": ["string", "null"],
            "description": "失敗した支払いの説明"
          },
          "fee_rate": {
            "type": "string",
            "description": "決済手数料率"
          },
          "refunded": {
            "type": "boolean",
            "description": "返金済みかどうか"
          },
          "amount_refunded": {
            "type": "integer",
            "description": "この支払いに対しての返金額"
          },
          "refund_reason": {
            "type": ["string", "null"],
            "description": "返金理由"
          },
          "subscription": {
            "type": ["string", "null"],
            "description": "sub_から始まる定期課金のID"
          },
          "metadata": {
            "type": ["object", "null"],
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          },
          "platform_fee": {
            "type": ["integer", "null"],
            "description": "[PAY.JP Platform](#platform-api) のみ\n\nプラットフォーマーに振り分けられる入金金額。"
          },
          "tenant": {
            "type": ["string", "null"],
            "description": "[PAY.JP Platform](#platform-api)のみ\n\nテナントID"
          },
          "platform_fee_rate": {
            "type": ["string", "null"],
            "description": "[PAY.JP Platform](#platform-api)のみ\n\n[テナント作成](#テナントを作成)時に指定したプラットフォーム利用料率(%)"
          },
          "total_platform_fee": {
            "type": ["integer", "null"],
            "description": "[PAY.JP Platform](#platform-api)のみ\n\nプラットフォーム利用料総額"
          },
          "three_d_secure_status": {
            "type": ["string", "null"],
            "description": "3Dセキュアの実施状況",
            "enum": ["unverified", "verified", "attempted", "failed", "error", null]
          },
          "term_id": {
            "type": ["string", "null"],
            "description": "[入金管理オブジェクトの刷新に伴い、2024/06/01以降に提供されます。](https://pay.jp/docs/migrate-transfer)\n\nこの支払いが関連付けられたTermオブジェクトのID"
          }
        },
        "required": ["id", "object", "livemode", "created", "amount", "currency", "paid", "captured", "card"]
      },
      "card": {
        "type": "object",
        "description": "cardオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "car_で始まる一意なオブジェクトを示す文字列",
            "example": "car_6845da1a8651f889bc432362dfcb"
          },
          "object": {
            "type": "string",
            "description": "\"card\"の固定文字列",
            "example": "card"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "カード作成時のUTCタイムスタンプ"
          },
          "last4": {
            "type": "string",
            "description": "カード番号の下4桁",
            "example": "4242"
          },
          "brand": {
            "type": "string",
            "description": "カードブランド",
            "example": "Visa"
          },
          "exp_month": {
            "type": "integer",
            "description": "カード有効期限の月"
          },
          "exp_year": {
            "type": "integer",
            "description": "カード有効期限の年"
          },
          "name": {
            "type": ["string", "null"],
            "description": "カード名義"
          },
          "address_city": {
            "type": ["string", "null"],
            "description": "請求先住所（市区町村）"
          },
          "address_line1": {
            "type": ["string", "null"],
            "description": "請求先住所（番地）"
          },
          "address_line2": {
            "type": ["string", "null"],
            "description": "請求先住所（建物名）"
          },
          "address_state": {
            "type": ["string", "null"],
            "description": "請求先住所（都道府県）"
          },
          "address_zip": {
            "type": ["string", "null"],
            "description": "請求先住所（郵便番号）"
          },
          "address_zip_check": {
            "type": "string",
            "description": "郵便番号の検証結果",
            "enum": ["passed", "failed", "unchecked"]
          },
          "cvc_check": {
            "type": "string",
            "description": "セキュリティコードの検証結果",
            "enum": ["passed", "failed", "unchecked"]
          },
          "fingerprint": {
            "type": "string",
            "description": "カード指紋"
          },
          "customer": {
            "type": ["string", "null"],
            "description": "このカードを保有する顧客ID"
          },
          "metadata": {
            "type": ["object", "null"],
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          },
          "three_d_secure_status": {
            "type": ["string", "null"],
            "description": "3Dセキュアの利用状況",
            "enum": ["available", "unavailable", null]
          },
          "email": {
            "type": ["string", "null"],
            "description": "メールアドレス"
          },
          "phone": {
            "type": ["string", "null"],
            "description": "電話番号"
          }
        },
        "required": ["id", "object", "livemode", "created", "last4", "brand", "exp_month", "exp_year", "fingerprint"]
      },
      "chargeCreateRequest": {
        "type": "object",
        "properties": {
          "amount": {
            "type": "integer",
            "description": "50~9,999,999の整数"
          },
          "currency": {
            "type": "string",
            "description": "3文字のISOコード(現状 \"jpy\" のみサポート)",
            "example": "jpy"
          },
          "product": {
            "type": "string",
            "description": "プロダクトID"
          },
          "customer": {
            "type": "string",
            "description": "顧客ID"
          },
          "card": {
            "type": "string",
            "description": "トークンIDまたはカードID"
          },
          "description": {
            "type": "string",
            "description": "概要"
          },
          "capture": {
            "type": "boolean",
            "description": "支払い処理を確定するかどうか"
          },
          "expiry_days": {
            "type": "integer",
            "description": "認証状態が失効するまでの日数"
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          },
          "platform_fee": {
            "type": "integer",
            "description": "[PAY.JP Platform](#platform-api) のみ設定可能\n\nプラットフォーマーに振り分けられる入金金額。"
          },
          "tenant": {
            "type": "string",
            "description": "[PAY.JP Platform](#platform-api) のみ設定可能\n\nテナントID"
          },
          "three_d_secure": {
            "type": "boolean",
            "description": "3Dセキュアを行うならtrue"
          }
        },
        "oneOf": [
          {
            "required": ["amount", "currency"]
          },
          {
            "required": ["product"]
          }
        ],
        "anyOf": [
          {
            "required": ["card"]
          },
          {
            "required": ["customer"]
          }
        ]
      },
      "chargeUpdateRequest": {
        "type": "object",
        "properties": {
          "description": {
            "type": "string",
            "description": "概要"
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        }
      },
      "chargeRefundRequest": {
        "type": "object",
        "properties": {
          "amount": {
            "type": "integer",
            "description": "1~9,999,999の整数"
          },
          "refund_reason": {
            "type": "string",
            "description": "返金理由 (255文字以内)"
          }
        }
      },
      "chargeReauthRequest": {
        "type": "object",
        "properties": {
          "expiry_days": {
            "type": "integer",
            "description": "認証状態が失効するまでの日数"
          }
        }
      },
      "chargeCaptureRequest": {
        "type": "object",
        "properties": {
          "amount": {
            "type": "integer",
            "description": "50~9,999,999の整数\n\nこれをセットすることで、支払い生成時の金額と異なる金額の支払い処理を行うことができます。\nただし支払い生成時の金額よりも少額である必要があるためご注意ください。\n\nセットした場合、レスポンスの `amount_refunded` に認証時の `amount` との差額が入ります。\n例えば、認証時に `amount=500` で作成し、 `amount=400` で支払い確定を行った場合、 `amount_refunded=100` となり、確定金額が400円に変更された状態で支払いが確定されます。"
          }
        }
      },
      "chargeList": {
        "type": "object",
        "description": "chargeオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/charge"
            }
          },
          "has_more": {
            "type": "boolean",
            "description": "さらにデータが存在するかどうか"
          },
          "url": {
            "type": "string",
            "description": "APIエンドポイントのURL"
          },
          "count": {
            "type": "integer",
            "description": "取得されたオブジェクトの総数"
          }
        },
        "required": ["object", "data"]
      },
      "error": {
        "type": "object",
        "description": "エラーオブジェクト",
        "properties": {
          "error": {
            "type": "object",
            "properties": {
              "status": {
                "type": "integer",
                "description": "HTTPステータスコード"
              },
              "type": {
                "type": "string",
                "description": "エラーの種類"
              },
              "message": {
                "type": "string",
                "description": "エラーメッセージ"
              },
              "param": {
                "type": ["string", "null"],
                "description": "エラーに関連するパラメータ名"
              },
              "code": {
                "type": ["string", "null"],
                "description": "エラーコード"
              }
            },
            "required": ["status", "type", "message"]
          }
        },
        "required": ["error"]
      }
    }
  }
}
