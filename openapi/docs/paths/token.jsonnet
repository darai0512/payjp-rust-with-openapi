local f = import '../common.jsonnet';

{
  "paths": {
    "/tokens": {
      "post": {
        "description": "Create new token",
        "requestBody": {
          "required": true,
          "content": {
            "application/x-www-form-urlencoded": {
              "encoding": {},
              "schema": {
                "type": "object",
                "required": [
                  "card[number]",
                  "card[exp_month]",
                  "card[exp_year]"
                ],
                "properties": {
                  "card[number]": {
                    "type": "string"
                  },
                  "card[exp_month]": {
                    "type": "string"
                  },
                  "card[exp_year]": {
                    "type": "string"
                  },
                  "card[cvc]": {
                    "type": "string"
                  },
                  "card[name]": {
                    "type": "string"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "The token you created",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/token"
                }
              }
            }
          },
          "default": {
            "description": "Error response.",
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
    "/tokens/{token}": {
      "get": {
        "description": "Info for a specific token",
        "parameters": [
          {
            "name": "token",
            "in": "path",
            "required": true,
            "description": "The id of the token to retrieve",
            "schema": {
              "type": "string"
            },
            "style": "simple"
          }
        ],
        "responses": {
          "200": {
            "description": "Expected response to a valid request",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/token"
                }
              }
            }
          },
          "default": {
            "description": "Error response.",
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
      "token": {
        "type": "object",
        "required": [
          "id",
          "card",
          "created",
          "livemode",
          "object",
          "used"
        ],
        "properties": {
          "id": {
            "type": "string",
            "description": "tok_で始まる一意なオブジェクトを示す文字列"
          },
          "card": {
            "description": "クレジットカードの情報を表すcardオブジェクト",
            "type": "object",
            "required": [
              "id"
            ],
            "properties": {
              "id": {
                "type": "string",
                "description": "car_で始まり一意なオブジェクトを示す、最大32桁の文字列"
              },
              "object": {
                "type": "string",
                "description": "\\\"card\\\"の固定文字列"
              },
              "created": {
                "type": "integer",
                "description": "カード作成時のタイムスタンプ"
              },
              "name": {
                "type": "string",
                "nullable": true,
                "description": "カード保有者名"
              },
              "last4": {
                "type": "string",
                "description": "カード番号の下四桁"
              },
              "exp_month": {
                "type": "integer",
                "description": "有効期限月"
              },
              "exp_year": {
                "type": "integer",
                "description": "有効期限年"
              },
              "brand": {
                "type": "string",
                "enum": [
                  "Visa",
                  "MasterCard",
                  "JCB",
                  "American Express",
                  "Diners Club",
                  "Discover"
                ],
                "description": "カードブランド名"
              },
              "cvc_check": {
                "type": "string",
                "description": "CVCコードチェックの結果"
              },
              "three_d_secure_status": {
                "type": "string",
                "description": "3Dセキュアの実施結果。\n加盟店において3Dセキュアが有効でない等未実施の場合null。\n"
              },
              "fingerprint": {
                "type": "string",
                "description": "このクレジットカード番号に紐づく値。\n同一番号のカードからは同一の値が生成されることが保証されており、 トークン化の度にトークンIDは変わりますが、この値は変わりません。\n"
              },
              "email": {
                "type": "string",
                "nullable": true,
                "description": "メールアドレス\n2024年8月以降、3Dセキュア認証の際にphoneまたはemailのデータ入力が求められます。\n"
              },
              "phone": {
                "type": "string",
                "nullable": true,
                "description": "E.164形式の電話番号 (e.g. 090-0123-4567（日本） => \"+819001234567\")\n2024年8月以降、3Dセキュア認証の際にphoneまたはemailのデータ入力が求められます。\n"
              },
              "address_state": {
                "type": "string",
                "nullable": true,
                "description": "都道府県"
              },
              "address_city": {
                "type": "string",
                "nullable": true,
                "description": "市区町村"
              },
              "address_line1": {
                "type": "string",
                "nullable": true,
                "description": "番地など"
              },
              "address_line2": {
                "type": "string",
                "nullable": true,
                "description": "建物名など"
              },
              "country": {
                "type": "string",
                "nullable": true,
                "description": "2桁のISOコード(e.g. JP)"
              },
              "address_zip": {
                "type": "string",
                "nullable": true,
                "description": "郵便番号"
              },
              "address_zip_check": {
                "type": "string",
                "description": "郵便番号存在チェックの結果"
              },
              "customer": {
                "type": "string",
                "nullable": true,
                "description": "顧客オブジェクトのID"
              },
              "metadata": {
                "type": "object",
                "description": "キーバリューの任意データ"
              }
            }
          },
          "created": {
            "type": "integer",
            "description": "このトークン作成時のタイムスタンプ"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "object": {
            "type": "string",
            "description": "\\\"token\\\"の固定文字列"
          },
          "used": {
            "type": "boolean",
            "description": "このトークンが使用済みかどうか"
          }
        },
        "x-stripeOperations": [
          f.Retrieve("/tokens/{token}"),
          f.Create("/tokens")
        ],
      }
    }
  }
}