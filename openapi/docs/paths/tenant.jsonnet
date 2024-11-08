{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP Tenant API specification in OpenAPI 3.0"
  },
  "paths": {
    "/tenants": {
      "post": {
        "summary": "テナントを作成",
        "description": "名前やIDなどを指定してテナントを作成します。\n\n作成したテナントはあとから更新・削除することができます。",
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/tenantCreateRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "作成されたtenantオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/tenant"
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
        "summary": "テナントリストを取得",
        "description": "テナントのリストを取得します。",
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
            "description": "tenantオブジェクトのlistオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/tenantList"
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
    "/tenants/{id}": {
      "get": {
        "summary": "テナント情報を取得",
        "description": "テナント情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "テナントID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "test"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したIDのtenantオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/tenant"
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
        "summary": "テナント情報を更新",
        "description": "生成したテナント情報を更新することができます。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "テナントID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "test"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/tenantUpdateRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "更新されたtenantオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/tenant"
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
        "summary": "テナントを削除",
        "description": "生成したテナント情報を削除します。\n\n削除したテナントと同じIDのテナントをもう一度生成することができますが、削除したテナントとは別のテナントとして扱われます。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "テナントID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "test"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "削除結果",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/tenantDeleteResponse"
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
    "/tenants/{id}/application_urls": {
      "post": {
        "summary": "テナントの審査申請ページのURLを作成",
        "description": "(Marketplace型アカウントのみ利用可能)テナントの審査申請ページのURLを作成します。\n\nテストモードの場合、実際の審査は行われず情報が保存されない為、常に新規申請になります。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "テナントID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "test"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "application_urlオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/application_url"
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
      "tenant": {
        "type": "object",
        "description": "tenantオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "`ten_`で始まる自動生成された一意な文字列、または作成時に指定した任意の文字列",
            "example": "test"
          },
          "object": {
            "type": "string",
            "description": "\"tenant\"の固定文字列",
            "example": "tenant"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "定期課金作成時のUTCタイムスタンプ"
          },
          "platform_fee_rate": {
            "type": "string",
            "description": "テナントのプラットフォーム利用料率(%)",
            "example": "10.15"
          },
          "payjp_fee_included": {
            "type": "boolean",
            "description": "テナントのプラットフォーム利用料にPAY.JP決済手数料を含めるかどうか"
          },
          "minimum_transfer_amount": {
            "type": "integer",
            "description": "最低入金額"
          },
          "bank_code": {
            "type": "string", "nullable": true,
            "description": "4桁の銀行コード"
          },
          "bank_branch_code": {
            "type": "string", "nullable": true,
            "description": "3桁の支店コード"
          },
          "bank_account_type": {
            "type": "string", "nullable": true,
            "description": "預金種別"
          },
          "bank_account_number": {
            "type": "string", "nullable": true,
            "description": "口座番号"
          },
          "bank_account_holder_name": {
            "type": "string", "nullable": true,
            "description": "口座名義"
          },
          "bank_account_status": {
            "type": "string", "nullable": true,
            "description": "口座状態。pending:未確認, success:入金確認済み, failed:入金不可能",
            "enum": ["pending", "success", "failed"]
          },
          "currencies_supported": {
            "type": "array",
            "description": "対応通貨のリスト(文字列)",
            "items": {
              "type": "string"
            }
          },
          "default_currency": {
            "type": "string",
            "description": "3文字のISOコード(現状 “jpy” のみサポート)",
            "example": "jpy"
          },
          "reviewed_brands": {
            "type": "array",
            "description": "申請情報を提出済のブランドの各種情報",
            "items": {
              "type": "object",
              "properties": {
                "brand": {
                  "type": "string",
                  "description": "ブランド名"
                },
                "status": {
                  "type": "string",
                  "description": "審査ステータス",
                  "enum": ["passed", "in_review", "declined"]
                },
                "available_date": {
                  "type": "integer", "nullable": true,
                  "format": "int64",
                  "description": "利用可能開始時刻のタイムスタンプ"
                }
              },
              "required": ["brand", "status"]
            }
          },
          "metadata": {
            "type": "object", "nullable": true,
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["id", "object", "livemode", "created", "platform_fee_rate", "payjp_fee_included", "minimum_transfer_amount"]
      },
      "tenantCreateRequest": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "description": "テナント名"
          },
          "id": {
            "type": "string",
            "description": "テナントIDとなる任意の文字列。一意にならないとエラーになります。また、未指定時は自動生成されます。"
          },
          "platform_fee_rate": {
            "type": "number",
            "format": "float",
            "description": "テナントのプラットフォーム利用料率(%)。小数点以下2桁まで入力可能。作成時に必須です。",
            "example": 10.15
          },
          "payjp_fee_included": {
            "type": "boolean",
            "description": "テナントのプラットフォーム利用料にPAY.JP決済手数料を含めるかどうか。デフォルトはfalse。作成時にのみ指定可能で、あとから変更はできません。"
          },
          "minimum_transfer_amount": {
            "type": "integer",
            "description": "最低入金額。デフォルトは1万円で下限は1000円。"
          },
          "bank_code": {
            "type": "string",
            "description": "4桁の銀行コード（Payouts型アカウントの場合は必須）"
          },
          "bank_branch_code": {
            "type": "string",
            "description": "3桁の支店コード（Payouts型アカウントの場合は必須）"
          },
          "bank_account_type": {
            "type": "string",
            "description": "預金種別（Payouts型アカウントの場合は必須）"
          },
          "bank_account_number": {
            "type": "string",
            "description": "口座番号（Payouts型アカウントの場合は必須）"
          },
          "bank_account_holder_name": {
            "type": "string",
            "description": "口座名義（Payouts型アカウントの場合は必須）"
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["name", "platform_fee_rate"]
      },
      "tenantUpdateRequest": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "description": "テナント名"
          },
          "platform_fee_rate": {
            "type": "number",
            "format": "float",
            "description": "テナントのプラットフォーム利用料率(%)。小数点以下2桁まで入力可能。最大95%"
          },
          "minimum_transfer_amount": {
            "type": "integer",
            "description": "最低入金額。デフォルトは1万円で下限は1000円。"
          },
          "bank_code": {
            "type": "string",
            "description": "4桁の銀行コード"
          },
          "bank_branch_code": {
            "type": "string",
            "description": "3桁の支店コード"
          },
          "bank_account_type": {
            "type": "string",
            "description": "預金種別"
          },
          "bank_account_number": {
            "type": "string",
            "description": "口座番号"
          },
          "bank_account_holder_name": {
            "type": "string",
            "description": "口座名義"
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
      "tenantDeleteResponse": {
        "type": "object",
        "properties": {
          "deleted": {
            "type": "boolean",
            "description": "`true`が入ります",
            "example": true
          },
          "id": {
            "type": "string",
            "description": "削除した定期課金ID",
            "example": "test"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          }
        },
        "required": ["deleted", "id", "livemode"]
      },
      "tenantList": {
        "type": "object",
        "description": "tenantオブジェクトのlistオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/tenant"
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
      "application_url": {
        "type": "object",
        "description": "application_urlオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "オブジェクト名 'application_url'",
            "example": "application_url"
          },
          "url": {
            "type": "string",
            "description": "テナントの審査申請URL"
          },
          "expires": {
            "type": "integer",
            "format": "int64",
            "description": "application_urlの使用期限のタイムスタンプ。発行から5分"
          }
        },
        "required": ["object", "url", "expires"]
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
                "type": "string", "nullable": true,
                "description": "エラーに関連するパラメータ名"
              },
              "code": {
                "type": "string", "nullable": true,
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
