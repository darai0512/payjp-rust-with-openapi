{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JPのBalanceオブジェクトと関連エンドポイントのAPI仕様"
  },
  "paths": {
    "/balances/{id}": {
      "get": {
        "summary": "残高を取得",
        "description": "特定の残高オブジェクトを取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "ba_で始まる残高オブジェクトのID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ba_013f3c308b771358605dd2445d60f"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したidのBalanceオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/balance"
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
    "/balances/{id}/statement_urls": {
      "post": {
        "summary": "取引明細一括ダウンロードURLを発行",
        "description": "Balanceに含まれるStatementすべての取引明細およびインボイスを一括ダウンロードできる一時URLを発行します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "ba_で始まる残高オブジェクトのID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "ba_013f3c308b771358605dd2445d60f"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/statementUrlsRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "取引明細ダウンロードURLオブジェクト",
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
    "/balances": {
      "get": {
        "summary": "残高リストを取得",
        "description": "残高リストを取得します。",
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
            "name": "since_due_date",
            "in": "query",
            "description": "入金予定日/振込期限日が指定したタイムスタンプ以降のデータのみ取得",
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          },
          {
            "name": "until_due_date",
            "in": "query",
            "description": "入金予定日/振込期限日が指定したタイムスタンプ以前のデータのみ取得",
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          },
          {
            "name": "state",
            "in": "query",
            "description": "stateが指定した値であるオブジェクトに限定",
            "schema": {
              "type": "string",
              "enum": ["collecting", "transfer", "claim"]
            }
          },
          {
            "name": "closed",
            "in": "query",
            "description": "closedが指定した値であるオブジェクトに限定",
            "schema": {
              "type": "boolean"
            }
          },
          {
            "name": "owner",
            "in": "query",
            "description": "Balanceの所有者で絞り込みます。以下の値が指定できます。`merchant`または`tenant`",
            "schema": {
              "type": "string",
              "enum": ["merchant", "tenant"]
            }
          },
          {
            "name": "tenant",
            "in": "query",
            "description": "指定したテナントが所有者であるオブジェクトに限定",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Balanceオブジェクトのリスト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/balanceList"
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
      "balance": {
        "type": "object",
        "description": "Balanceオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"balance\"の固定文字列",
            "example": "balance"
          },
          "id": {
            "type": "string",
            "description": "ba_で始まる一意なオブジェクトを示す文字列",
            "example": "ba_013f3c308b771358605dd2445d60f"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "オブジェクト作成時刻のUTCタイムスタンプ"
          },
          "tenant_id": {
            "type": ["string", "null"],
            "description": "オブジェクトを所有するTenantのID"
          },
          "net": {
            "type": "integer",
            "description": "関連付けられているStatementの総額"
          },
          "statements": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/statement"
            },
            "description": "関連付けられているStatementオブジェクトのリスト"
          },
          "state": {
            "type": "string",
            "description": "Balanceの状態",
            "enum": ["collecting", "transfer", "claim"]
          },
          "closed": {
            "type": "boolean",
            "description": "このBalanceの清算が終了していればtrue"
          },
          "closed_date": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "精算が終了した日時のタイムスタンプ"
          },
          "due_date": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "入金予定日/請求期限日のタイムスタンプ"
          },
          "bank_info": {
            "$ref": "#/components/schemas/bank_info",
            "description": "入金先口座情報"
          }
        },
        "required": ["object", "id", "livemode", "created", "net", "statements", "state", "closed"]
      },
      "bank_info": {
        "type": "object",
        "description": "入金先口座情報",
        "properties": {
          "bank_code": {
            "type": "string",
            "description": "銀行コード"
          },
          "bank_branch_code": {
            "type": "string",
            "description": "支店番号"
          },
          "bank_account_type": {
            "type": "string",
            "description": "口座種別"
          },
          "bank_account_number": {
            "type": "string",
            "description": "口座番号"
          },
          "bank_account_holder_name": {
            "type": "string",
            "description": "口座名義"
          },
          "bank_account_status": {
            "type": "string",
            "description": "最新振込結果",
            "enum": ["success", "failed", "pending"]
          }
        },
        "required": [
          "bank_code",
          "bank_branch_code",
          "bank_account_type",
          "bank_account_number",
          "bank_account_holder_name",
          "bank_account_status"
        ]
      },
      "statement": {
        "type": "object",
        "description": "Statementオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"statement\"の固定文字列",
            "example": "statement"
          },
          "id": {
            "type": "string",
            "description": "st_で始まる一意なオブジェクトを示す文字列",
            "example": "st_be6b875435edcceb598aca31edd49"
          },
          "balance_id": {
            "type": "string",
            "description": "関連するBalanceのID",
            "example": "ba_013f3c308b771358605dd2445d60f"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "オブジェクト作成時刻のUTCタイムスタンプ"
          },
          "items": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/statement_item"
            },
            "description": "Statementに含まれる項目のリスト"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "net": {
            "type": "integer",
            "description": "Statementの総額"
          },
          "tenant_id": {
            "type": ["string", "null"],
            "description": "オブジェクトを所有するTenantのID"
          },
          "term": {
            "$ref": "#/components/schemas/term",
            "nullable": true,
            "description": "関連するTermオブジェクト"
          },
          "title": {
            "type": ["string", "null"],
            "description": "タイトル"
          },
          "updated": {
            "type": "integer",
            "format": "int64",
            "description": "オブジェクト更新時刻のUTCタイムスタンプ"
          },
          "type": {
            "type": "string",
            "description": "Statementのタイプ"
          }
        },
        "required": [
          "object",
          "id",
          "balance_id",
          "created",
          "items",
          "livemode",
          "net",
          "updated",
          "type"
        ]
      },
      "statement_item": {
        "type": "object",
        "description": "Statementに含まれる項目",
        "properties": {
          "amount": {
            "type": "integer",
            "description": "金額"
          },
          "name": {
            "type": "string",
            "description": "項目名"
          },
          "subject": {
            "type": "string",
            "description": "項目のサブジェクト"
          },
          "tax_rate": {
            "type": "string",
            "description": "税率"
          }
        },
        "required": ["amount", "name", "subject", "tax_rate"]
      },
      "term": {
        "type": "object",
        "description": "Termオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "\"term\"の固定文字列",
            "example": "term"
          },
          "id": {
            "type": "string",
            "description": "tm_で始まる一意なオブジェクトを示す文字列",
            "example": "tm_523e1651f76f4f15b61cc66306f37"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "charge_count": {
            "type": "integer",
            "description": "このTerm内のチャージ数"
          },
          "dispute_count": {
            "type": "integer",
            "description": "このTerm内のディスプート数"
          },
          "refund_count": {
            "type": "integer",
            "description": "このTerm内の返金数"
          },
          "start_at": {
            "type": "integer",
            "format": "int64",
            "description": "Termの開始時刻のUTCタイムスタンプ"
          },
          "end_at": {
            "type": "integer",
            "format": "int64",
            "description": "Termの終了時刻のUTCタイムスタンプ"
          }
        },
        "required": [
          "object",
          "id",
          "livemode",
          "charge_count",
          "dispute_count",
          "refund_count",
          "start_at",
          "end_at"
        ]
      },
      "balanceList": {
        "type": "object",
        "description": "Balanceオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/balance"
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
      "statement_url": {
        "type": "object",
        "description": "取引明細ダウンロードURLオブジェクト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'statement_url'",
            "example": "statement_url"
          },
          "url": {
            "type": "string",
            "description": "取引明細書ダウンロードURL"
          },
          "expires": {
            "type": "integer",
            "format": "int64",
            "description": "有効期限のタイムスタンプ"
          }
        },
        "required": ["object", "url", "expires"]
      },
      "statementUrlsRequest": {
        "type": "object",
        "properties": {
          "platformer": {
            "type": "boolean",
            "description": "`true`を指定するとプラットフォーム手数料に関する明細がダウンロードできるURLを発行します。デフォルトは`false`です。"
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
      }
    }
  }
}
