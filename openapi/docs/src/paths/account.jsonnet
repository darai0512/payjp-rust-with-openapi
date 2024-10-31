{
  "paths": {
    "/accounts": {
      "get": {
        "summary": "アカウント情報を取得",
        "description": "あなたのアカウント情報を取得します。",
        "responses": {
          "200": {
            "description": "Accountオブジェクトの詳細情報",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/account"
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
      "account": {
        "type": "object",
        "description": "Accountオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"account\"の固定文字列",
            "example": "account"
          },
          "id": {
            "type": "string",
            "description": "acct_で始まる一意なオブジェクトを示す文字列",
            "example": "acct_8a27db83a7bf11a0c12b0c2833f"
          },
          "email": {
            "type": "string",
            "description": "メールアドレス",
            "example": "liveaccount@example.com"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "このアカウント作成時のUTCタイムスタンプ"
          },
          "merchant": {
            "$ref": "#/components/schemas/merchant"
          },
          "team_id": {
            "type": ["string", "null"],
            "description": "このアカウントに紐付くチームID"
          }
        },
        "required": ["object", "id", "email", "created", "merchant"]
      },
      "merchant": {
        "type": "object",
        "description": "Merchantオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"merchant\"の固定文字列",
            "example": "merchant"
          },
          "id": {
            "type": "string",
            "description": "acct_mch_で始まる一意なオブジェクトを示す文字列",
            "example": "acct_mch_21a96cb898ceb6db0932983"
          },
          "bank_enabled": {
            "type": "boolean",
            "description": "入金先銀行口座情報が設定済みかどうか"
          },
          "brands_accepted": {
            "type": "array",
            "items": {
              "type": "string"
            },
            "description": "本番環境で利用可能なカードブランドのリスト",
            "example": [
              "Visa",
              "MasterCard",
              "JCB",
              "American Express",
              "Diners Club",
              "Discover"
            ]
          },
          "currencies_supported": {
            "type": "array",
            "items": {
              "type": "string"
            },
            "description": "対応通貨のリスト",
            "example": ["jpy"]
          },
          "default_currency": {
            "type": "string",
            "description": "3文字のISOコード（現状 \"jpy\" のみサポート）",
            "example": "jpy"
          },
          "details_submitted": {
            "type": "boolean",
            "description": "本番環境申請情報が提出済みかどうか"
          },
          "business_type": {
            "type": ["string", "null"],
            "description": "業務形態"
          },
          "country": {
            "type": "string",
            "description": "所在国",
            "example": "JP"
          },
          "charge_type": {
            "type": ["array", "null"],
            "items": {
              "type": "string"
            },
            "description": "支払い方法種別のリスト"
          },
          "product_name": {
            "type": ["string", "null"],
            "description": "販売商品名"
          },
          "product_type": {
            "type": ["array", "null"],
            "items": {
              "type": "string"
            },
            "description": "販売商品の種類リスト"
          },
          "livemode_enabled": {
            "type": "boolean",
            "description": "本番環境が有効かどうか"
          },
          "livemode_activated_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "本番環境が許可された日時のUTCタイムスタンプ"
          },
          "site_published": {
            "type": ["boolean", "null"],
            "description": "申請対象のサイトがオープン済みかどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "登録日時"
          }
        },
        "required": [
          "object",
          "id",
          "bank_enabled",
          "brands_accepted",
          "currencies_supported",
          "default_currency",
          "details_submitted",
          "country",
          "livemode_enabled",
          "created"
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
