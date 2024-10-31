{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "0.0.1",
    "description": "PAY.JP API (unofficial)",
    "contact": {
      "email": "darai0512@yahoo.co.jp",
      "name": "Daiki Arai"
    }
  },
  "servers": [
    {
      "url": "https://api.pay.jp/v1"
    }
  ],
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
    },
    "/terms/{term}": {
      "get": {
        "summary": "集計区間オブジェクトを取得",
        "description": "指定されたIDの集計区間（Termオブジェクト）を取得します。",
        "parameters": [
          {
            "name": "term",
            "in": "path",
            "description": "TermオブジェクトのID（tm_で始まる一意な文字列）",
            "required": true,
            "schema": {
              "type": "string"
            },
            "style": "simple"
          }
        ],
        "responses": {
          "200": {
            "description": "Termオブジェクトの詳細情報",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/term"
                }
              }
            }
          },
          "default": {
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
    "/terms": {
      "get": {
        "summary": "集計区間のリストを取得",
        "description": "集計区間（Termオブジェクト）のリストを取得します。",
        "parameters": [
          {
            "name": "limit",
            "in": "query",
            "description": "取得するデータ数の最大値（1〜100）。デフォルトは10。",
            "required": false,
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
            "description": "データ取得の開始位置。デフォルトは0。",
            "required": false,
            "schema": {
              "type": "integer",
              "default": 0,
              "minimum": 0
            }
          },
          {
            "name": "since_start_at",
            "in": "query",
            "description": "start_atが指定したタイムスタンプ以降のオブジェクトを取得",
            "required": false,
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          },
          {
            "name": "until_start_at",
            "in": "query",
            "description": "start_atが指定したタイムスタンプ以前のオブジェクトを取得",
            "required": false,
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Termオブジェクトのリスト",
            "content": {
              "application/json": {
                "schema": {
                  "properties": {
                    "object": {
                      "type": "string",
                      "enum": [
                        "list"
                      ],
                      "description": "\"list\"の固定文字列"
                    },
                    "url": {
                      "type": "string",
                      "description": "APIエンドポイントのURL",
                      "example": "/v1/terms"
                    },
                    "has_more": {
                      "type": "boolean",
                      "description": "さらにデータがあるかどうか"
                    },
                    "data": {
                      "type": "array",
                      "description": "オブジェクトの配列",
                      "items": {
                        "$ref": "#/components/schemas/term"
                      }
                    },
                    "count": {
                      "type": "integer",
                      "description": "取得されたオブジェクトの総数"
                    }
                  },
                  "type": "object",
                  "required": ["object", "data", "url", "has_more", "count"]
                }
              }
            }
          },
          "default": {
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
          {
            "method_name": "retrieve",
            "method_on": "service",
            "method_type": "retrieve",
            "operation": "get",
            "path": "/tokens/{token}"
          },
          {
            "method_name": "create",
            "method_on": "service",
            "method_type": "create",
            "operation": "post",
            "path": "/tokens"
          }
        ],
      },
      "term": {
        "type": "object",
        "description": "Term（集計区間）オブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"term\"の固定文字列",
            "example": "term"
          },
          "id": {
            "type": "string",
            "description": "tm_で始まる一意なオブジェクトを示す文字列",
            "example": "tm_425000e2a448b39b83480a358fee5"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか。"
          },
          "start_at": {
            "type": "integer",
            "format": "int64",
            "description": "区間開始時刻のタイムスタンプ",
            "example": 1696086000
          },
          "end_at": {
            "type": "integer",
            "nullable":  true,
            "format": "int64",
            "description": "区間終了時刻のタイムスタンプ。Termが表す区間はstart_at以上end_at未満の範囲となります。翌サイクルのTermの場合`null`を返します。",
            "example": null
          },
          "closed": {
            "type": "boolean",
            "description": "締め処理が完了済みならTrue"
          },
          "charge_count": {
            "type": "integer",
            "description": "この区間内で確定された支払いの数"
          },
          "refund_count": {
            "type": "integer",
            "description": "この区間内で確定された返金の数"
          },
          "dispute_count": {
            "type": "integer",
            "description": "この区間内で確定されたチャージバック/チャージバックキャンセルの数"
          }
        },
        "required": ["id", "object", "livemode", "start_at", "closed", "charge_count", "refund_count", "dispute_count"],
        "x-stripeOperations": [
          {
            "method_name": "retrieve",
            "method_on": "service",
            "method_type": "retrieve",
            "operation": "get",
            "path": "/terms/{term}"
          },
          {
            "method_name": "list",
            "method_on": "service",
            "method_type": "list",
            "operation": "get",
            "path": "/terms"
          }
        ]
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
                "type": "string",
                "description": "エラーが関連するパラメータ名"
              },
              "code": {
                "type": "string",
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