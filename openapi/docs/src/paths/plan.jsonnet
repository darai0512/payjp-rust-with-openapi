{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP Plan API specification in OpenAPI 3.0"
  },
  "paths": {
    "/plans": {
      "get": {
        "summary": "プランリストを取得",
        "description": "生成したプランのリストを取得します。",
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
            "description": "ここに指定したタイムスタンプ以降に作成されたデータを取得",
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          },
          {
            "name": "until",
            "in": "query",
            "description": "ここに指定したタイムスタンプ以前に作成されたデータを取得",
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Planオブジェクトのリスト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/planList"
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
        "summary": "プランを作成",
        "description": "金額や通貨などを指定して定期購入に利用するプランを生成します。",
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/planCreateRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "作成されたPlanオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/plan"
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
    "/plans/{id}": {
      "get": {
        "summary": "プラン情報を取得",
        "description": "特定のプラン情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "プランID。一意なplanオブジェクトを識別する文字列。",
            "required": true,
            "schema": {
              "type": "string",
              "example": "pln_45dd3268a18b2837d52861716260"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したidのPlanオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/plan"
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
        "summary": "プランを更新",
        "description": "プラン情報を更新します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "プランID。一意なplanオブジェクトを識別する文字列。",
            "required": true,
            "schema": {
              "type": "string",
              "example": "pln_45dd3268a18b2837d52861716260"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/planUpdateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "更新されたPlanオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/plan"
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
        "summary": "プランを削除",
        "description": "プランを削除します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "プランID。一意なplanオブジェクトを識別する文字列。",
            "required": true,
            "schema": {
              "type": "string",
              "example": "pln_45dd3268a18b2837d52861716260"
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
    }
  },
  "components": {
    "schemas": {
      "plan": {
        "type": "object",
        "description": "Planオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "プランID。一意なplanオブジェクトを識別する文字列。",
            "example": "pln_45dd3268a18b2837d52861716260"
          },
          "object": {
            "type": "string",
            "description": "\"plan\"の固定文字列",
            "example": "plan"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "プラン作成時のUTCタイムスタンプ"
          },
          "amount": {
            "type": "integer",
            "description": "プランの金額"
          },
          "currency": {
            "type": "string",
            "description": "3文字のISOコード(現状 \"jpy\" のみサポート)",
            "example": "jpy"
          },
          "interval": {
            "type": "string",
            "description": "課金周期(\"month\"もしくは\"year\")",
            "enum": ["month", "year"]
          },
          "name": {
            "type": ["string", "null"],
            "description": "プラン名"
          },
          "trial_days": {
            "type": ["integer", "null"],
            "description": "トライアル日数(0-365)"
          },
          "billing_day": {
            "type": ["integer", "null"],
            "description": "月次プランの課金日(1-31, 年次の場合は\"null\")"
          },
          "metadata": {
            "type": ["object", "null"],
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["id", "object", "livemode", "created", "amount", "currency", "interval"]
      },
      "planCreateRequest": {
        "type": "object",
        "properties": {
          "amount": {
            "type": "integer",
            "description": "50~9,999,999の整数",
            "minimum": 50,
            "maximum": 9999999
          },
          "currency": {
            "type": "string",
            "description": "3文字のISOコード(現状 \"jpy\" のみサポート)",
            "example": "jpy"
          },
          "interval": {
            "type": "string",
            "description": "課金周期(\"month\"もしくは\"year\")",
            "enum": ["month", "year"]
          },
          "id": {
            "type": "string",
            "description": "任意のプランID。一意に識別できる必要があり、重複する値を設定するとエラーとなります。"
          },
          "name": {
            "type": "string",
            "description": "プランの名前"
          },
          "trial_days": {
            "type": "integer",
            "description": "トライアル日数",
            "minimum": 0,
            "maximum": 365
          },
          "billing_day": {
            "type": "integer",
            "description": "月次プラン(`interval=month`)のみに指定可能な課金日(1〜31)",
            "minimum": 1,
            "maximum": 31
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["amount", "currency", "interval"]
      },
      "planUpdateRequest": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "description": "プランの名前"
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
      "planList": {
        "type": "object",
        "description": "Planオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/plan"
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
            "description": "削除したプランID"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          }
        },
        "required": ["deleted", "id", "livemode"]
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