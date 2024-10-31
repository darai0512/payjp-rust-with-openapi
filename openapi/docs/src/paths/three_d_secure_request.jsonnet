{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP ThreeDSecureRequest API specification in OpenAPI 3.0"
  },
  "paths": {
    "/three_d_secure_requests": {
      "post": {
        "summary": "3Dセキュアを作成",
        "description": "顧客カードIDを指定して3Dセキュアリクエストを作成します。",
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/threeDSecureRequestCreateRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "作成されたthree_d_secure_requestオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/three_d_secure_request"
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
        "summary": "3Dセキュアリクエストリストを取得",
        "description": "3Dセキュアリクエスト情報のリストを取得します。",
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
            "name": "resource_id",
            "in": "query",
            "description": "3Dセキュア処理対象リソースのID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "tenant_id",
            "in": "query",
            "description": "テナントID",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "three_d_secure_requestオブジェクトのlistオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/threeDSecureRequestList"
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
    "/three_d_secure_requests/{id}": {
      "get": {
        "summary": "3Dセキュアリクエスト情報を取得",
        "description": "3Dセキュアリクエスト情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "tdsr_で始まる一意なオブジェクトを示す文字列",
            "required": true,
            "schema": {
              "type": "string",
              "example": "tdsr_ed15fa4e2a6300d5971b1b69b827"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したidのthree_d_secure_requestオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/three_d_secure_request"
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
      "three_d_secure_request": {
        "type": "object",
        "description": "three_d_secure_requestオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "tdsr_で始まる一意なオブジェクトを示す文字列",
            "example": "tdsr_125192559c91c4011c1ff56f50a"
          },
          "resource_id": {
            "type": "string",
            "description": "3Dセキュア処理対象リソースのID",
            "example": "car_4ec110e0700daf893160424fe03c"
          },
          "object": {
            "type": "string",
            "description": "\"three_d_secure_request\"の固定文字列",
            "example": "three_d_secure_request"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "3Dセキュアリクエスト作成時のUTCタイムスタンプ"
          },
          "state": {
            "type": "string",
            "description": "3Dセキュア認証の現在の状態",
            "enum": ["created", "in_progress", "result_received", "finished"]
          },
          "started_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "認証開始時のUTCタイムスタンプ\nカード会社画面での認証を始める際にセットされます。"
          },
          "result_received_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "認証終了時のUTCタイムスタンプ\nカード会社画面での認証を終えた後にセットされます。"
          },
          "finished_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "認証終了、かつ3Dセキュアリクエストが完了した時のUTCタイムスタンプ\n顧客カードに対する3Dセキュアにおいてはカード会社画面での認証を終えた後にセットされます。"
          },
          "expired_at": {
            "type": ["integer", "null"],
            "format": "int64",
            "description": "3Dセキュアリクエストが期限切れとなった時刻のUTCタイムスタンプ\n3Dセキュア認証が完了していれば値はセットされません。"
          },
          "tenant_id": {
            "type": ["string", "null"],
            "description": "テナントID"
          },
          "three_d_secure_status": {
            "type": "string",
            "description": "3Dセキュアの認証結果\n値については`charge.three_d_secure_status`に同じ",
            "enum": [
              "unverified",
              "verified",
              "attempted",
              "not_supported",
              "error",
              "failed",
              "not_enrolled"
            ]
          }
        },
        "required": ["id", "resource_id", "object", "livemode", "created", "state"]
      },
      "threeDSecureRequestCreateRequest": {
        "type": "object",
        "properties": {
          "resource_id": {
            "type": "string",
            "description": "顧客カードID",
            "example": "car_xxxxxx"
          },
          "tenant_id": {
            "type": "string",
            "description": "テナントID。PAY.JP Platform のみ設定可能"
          }
        },
        "required": ["resource_id"]
      },
      "threeDSecureRequestList": {
        "type": "object",
        "description": "three_d_secure_requestオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/three_d_secure_request"
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
