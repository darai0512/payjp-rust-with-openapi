{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP Statement API specification in OpenAPI 3.0"
  },
  "paths": {
    "/statements/{id}": {
      "get": {
        "summary": "取引明細を取得",
        "description": "取引明細を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "オブジェクトのユニークID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "st_178fd25dc7ab7b75906f5d4c4b0e6"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したidのstatementオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/statement"
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
    "/statements/{id}/statement_urls": {
      "post": {
        "summary": "取引明細ダウンロードURLを発行",
        "description": "取引明細およびインボイスをダウンロードできる一時URLを発行します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "オブジェクトのユニークID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "st_178fd25dc7ab7b75906f5d4c4b0e6"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/statementUrlRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Statement URL オブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/statement_url"
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
    "/statements": {
      "get": {
        "summary": "取引明細リストを取得",
        "description": "取引明細リストを取得します。",
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
            "name": "owner",
            "in": "query",
            "description": "取引明細の発行対象で絞り込みます。以下の値が指定できます。\n\n| owner | 絞り込み対象 |\n| ----- | ------------ |\n| merchant | 加盟店に向けて発行されたもの |\n| tenant | テナントに向けて発行されたもの |",
            "schema": {
              "type": "string",
              "enum": ["merchant", "tenant"]
            }
          },
          {
            "name": "source_transfer",
            "in": "query",
            "description": "取引明細の生成元オブジェクトで絞り込みます。\n\ntransferオブジェクトもしくは tenant_transferオブジェクトのIDを指定します。",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "tenant",
            "in": "query",
            "description": "テナントのIDで絞り込みます。",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "term",
            "in": "query",
            "description": "集計区間のIDで絞り込みます。",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "type",
            "in": "query",
            "description": "typeの値で絞り込みます。",
            "schema": {
              "type": "string",
              "enum": ["sales", "service_fee", "forfeit", "transfer_fee", "misc"]
            }
          }
        ],
        "responses": {
          "200": {
            "description": "statementオブジェクトのlistオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/statementList"
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
      "statement_item": {
        "type": "object",
        "description": "Statement Item Object",
        "properties": {
          "subject": {
            "type": "string",
            "description": "集計項目"
          },
          "name": {
            "type": "string",
            "description": "Subjectに対応する表示名"
          },
          "amount": {
            "type": "integer",
            "description": "集計された金額\n正の値は加盟店への支払額、負の値は請求額を表します。"
          },
          "tax_rate": {
            "type": "string",
            "description": "税率(パーセント表記)。小数点以下2桁までの数値の文字列型。"
          }
        },
        "required": ["subject", "name", "amount", "tax_rate"]
      },
      "statement": {
        "type": "object",
        "description": "Statement Object",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"statement\"の固定文字列",
            "example": "statement"
          },
          "id": {
            "type": "string",
            "description": "オブジェクトのユニークID",
            "example": "st_178fd25dc7ab7b75906f5d4c4b0e6"
          },
          "livemode": {
            "type": "boolean",
            "description": "livemodeオブジェクトならtrue"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "作成時刻のUTCタイムスタンプ"
          },
          "title": {
            "type": ["string", "null"],
            "description": "取引明細のタイトル"
          },
          "tenant_id": {
            "type": ["string", "null"],
            "description": "オブジェクトを所有するTenantのID"
          },
          "type": {
            "type": "string",
            "description": "取引明細の区分",
            "enum": ["sales", "service_fee", "forfeit", "transfer_fee", "misc"],
            "example": "sales"
          },
          "net": {
            "type": "integer",
            "description": "含まれるstatement_itemの金額合計"
          },
          "updated": {
            "type": "integer",
            "format": "int64",
            "description": "更新時刻のUTCタイムスタンプ"
          },
          "term": {
            "type": ["object", "null"],
            "description": "このStatementの生成元となったTermオブジェクト"
          },
          "balance_id": {
            "type": ["string", "null"],
            "description": "このStatementが関連付けられているBalanceのID"
          },
          "items": {
            "type": "array",
            "description": "statement_itemオブジェクトのリスト",
            "items": {
              "$ref": "#/components/schemas/statement_item"
            }
          }
        },
        "required": ["object", "id", "livemode", "created", "type", "net", "updated", "items"]
      },
      "statement_url": {
        "type": "object",
        "description": "Statement URL Object",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 \"statement_url\"",
            "example": "statement_url"
          },
          "url": {
            "type": "string",
            "description": "取引明細書ダウンロードURL"
          },
          "expires": {
            "type": "integer",
            "format": "int64",
            "description": "有効期限のタイムスタンプ。\n有効期限は発行から1時間です。"
          }
        },
        "required": ["object", "url", "expires"]
      },
      "statementUrlRequest": {
        "type": "object",
        "properties": {
          "platformer": {
            "type": "boolean",
            "description": "`true`を指定するとプラットフォーム手数料に関する明細がダウンロードできるURLを発行します。"
          }
        }
      },
      "statementList": {
        "type": "object",
        "description": "statementオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/statement"
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
