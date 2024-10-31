{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JPのCustomerオブジェクトと関連エンドポイントのAPI仕様"
  },
  "paths": {
    "/customers": {
      "post": {
        "summary": "顧客を作成",
        "description": "メールアドレスやIDなどを指定して顧客を作成します。作成と同時にカード情報を登録する場合、トークンIDを指定します。",
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/customerCreateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "作成されたCustomerオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/customer"
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
        "summary": "顧客リストを取得",
        "description": "生成した顧客情報のリストを取得します。リストは、直近で生成された順番に取得されます。",
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
          }
        ],
        "responses": {
          "200": {
            "description": "Customerオブジェクトのリスト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/customerList"
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
    "/customers/{id}": {
      "get": {
        "summary": "顧客情報を取得",
        "description": "生成した顧客情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Customerオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/customer"
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
        "summary": "顧客情報を更新",
        "description": "生成した顧客情報を更新したり、新たなカードを顧客に追加することができます。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/customerUpdateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "更新されたCustomerオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/customer"
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
      "delete": {
        "summary": "顧客を削除",
        "description": "顧客を削除します。顧客に紐付く定期課金がある場合は、同時にそれらの定期課金も削除されます。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "削除結果",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/deleteResponse"
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
    "/customers/{id}/cards": {
      "post": {
        "summary": "顧客のカードを作成",
        "description": "トークンIDを指定して、新たにカードを追加します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/cardCreateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "作成されたCardオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/card"
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
        "summary": "顧客のカードリストを取得",
        "description": "顧客の保持しているカードリストを取得します。リストは、直近で生成された順番に取得されます。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          },
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
          }
        ],
        "responses": {
          "200": {
            "description": "Cardオブジェクトのリスト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/cardList"
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
    "/customers/{id}/cards/{card_id}": {
      "get": {
        "summary": "顧客のカード情報を取得",
        "description": "顧客の特定のカード情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          },
          {
            "name": "card_id",
            "in": "path",
            "description": "カードID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "car_6845da1a8651f889bc432362dfcb"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Cardオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/card"
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
        "summary": "顧客のカードを更新",
        "description": "顧客の特定のカード情報を更新します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          },
          {
            "name": "card_id",
            "in": "path",
            "description": "カードID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "car_6845da1a8651f889bc432362dfcb"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/cardUpdateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "更新されたCardオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/card"
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
      "delete": {
        "summary": "顧客のカードを削除",
        "description": "顧客の特定のカードを削除します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "顧客ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "cus_121673955bd7aa144de5a8f6c262"
            }
          },
          {
            "name": "card_id",
            "in": "path",
            "description": "カードID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "car_6845da1a8651f889bc432362dfcb"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "削除結果",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/deleteResponse"
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
      "customer": {
        "type": "object",
        "description": "Customerオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"customer\"の固定文字列",
            "example": "customer"
          },
          "id": {
            "type": "string",
            "description": "一意なオブジェクトを示す文字列",
            "example": "cus_121673955bd7aa144de5a8f6c262"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "この顧客作成時のUTCタイムスタンプ"
          },
          "default_card": {
            "type": ["string", "null"],
            "description": "支払いにデフォルトで使用されるカードのID"
          },
          "cards": {
            "$ref": "#/components/schemas/cardList"
          },
          "email": {
            "type": ["string", "null"],
            "description": "メールアドレス"
          },
          "description": {
            "type": ["string", "null"],
            "description": "概要"
          },
          "subscriptions": {
            "$ref": "#/components/schemas/subscriptionList"
          },
          "metadata": {
            "type": ["object", "null"],
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["object", "id", "livemode", "created"]
      },
      "card": {
        "type": "object",
        "description": "Cardオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"card\"の固定文字列",
            "example": "card"
          },
          "id": {
            "type": "string",
            "description": "car_で始まり一意なオブジェクトを示す文字列",
            "example": "car_6845da1a8651f889bc432362dfcb"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "カード作成時のタイムスタンプ"
          },
          "name": {
            "type": ["string", "null"],
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
            "description": "カードブランド名"
          },
          "cvc_check": {
            "type": "string",
            "description": "トークン生成時の`cvc`の値のチェックの結果"
          },
          "fingerprint": {
            "type": "string",
            "description": "このクレジットカード番号に紐づく値"
          },
          "metadata": {
            "type": ["object", "null"],
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          },
          "three_d_secure_status": {
            "type": "string",
            "description": "トークン3Dセキュアの結果"
          },
          "email": {
            "type": ["string", "null"],
            "description": "メールアドレス"
          },
          "phone": {
            "type": ["string", "null"],
            "description": "E.164形式の電話番号"
          }
        },
        "required": ["object", "id", "created", "last4", "exp_month", "exp_year", "brand"]
      },
      "customerCreateRequest": {
        "type": "object",
        "properties": {
          "email": {
            "type": "string",
            "description": "メールアドレス"
          },
          "description": {
            "type": "string",
            "description": "概要"
          },
          "id": {
            "type": "string",
            "description": "顧客ID"
          },
          "card": {
            "type": "string",
            "description": "トークンID(トークンIDを指定)"
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
      "customerUpdateRequest": {
        "type": "object",
        "properties": {
          "email": {
            "type": "string",
            "description": "メールアドレス"
          },
          "description": {
            "type": "string",
            "description": "概要"
          },
          "default_card": {
            "type": "string",
            "description": "保持しているカードID"
          },
          "card": {
            "type": "string",
            "description": "トークンID(トークンIDを指定)"
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
      "cardCreateRequest": {
        "type": "object",
        "properties": {
          "card": {
            "type": "string",
            "description": "[トークンID](#tokenオブジェクト)"
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          },
          "default": {
            "type": "boolean",
            "description": "メイン利用のカードに設定するかどうか"
          }
        }
      },
      "cardUpdateRequest": {
        "type": "object",
        "properties": {
          "address_state": {
            "type": "string",
            "description": "都道府県"
          },
          "address_city": {
            "type": "string",
            "description": "市区町村"
          },
          "address_line1": {
            "type": "string",
            "description": "番地など"
          },
          "address_line2": {
            "type": "string",
            "description": "建物名など"
          },
          "address_zip": {
            "type": "string",
            "description": "郵便番号"
          },
          "country": {
            "type": "string",
            "description": "2桁のISOコード(e.g. JP)"
          },
          "name": {
            "type": "string",
            "description": "カード保有者名"
          },
          "email": {
            "type": "string",
            "description": "メールアドレス"
          },
          "phone": {
            "type": "string",
            "description": "E.164形式の電話番号"
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
      "cardList": {
        "type": "object",
        "description": "Cardオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/card"
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
      "customerList": {
        "type": "object",
        "description": "Customerオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/customer"
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
      "deleteResponse": {
        "type": "object",
        "properties": {
          "deleted": {
            "type": "boolean",
            "description": "`true`が入ります"
          },
          "id": {
            "type": "string",
            "description": "削除したオブジェクトのID"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          }
        }
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
      },
      "subscriptionList": {
        "type": "object",
        "description": "Subscriptionオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/subscription"
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
      "subscription": {
        "type": "object",
        "description": "Subscriptionオブジェクト",
        "properties": {
          // Subscription properties
        }
      }
    }
  }
}
