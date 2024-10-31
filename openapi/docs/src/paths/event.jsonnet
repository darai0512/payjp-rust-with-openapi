{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP Event API specification in OpenAPI 3.0"
  },
  "paths": {
    "/events": {
      "get": {
        "summary": "イベントリストを取得",
        "description": "イベントリストを取得します。",
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
            "name": "resource_id",
            "in": "query",
            "description": "取得するeventに紐づくAPIリソースのID (e.g. customer.id)",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "object",
            "in": "query",
            "description": "取得するeventに紐づくAPIリソースのobject。値はリソース名(e.g. customer, charge)",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "type",
            "in": "query",
            "description": "取得するeventのtype",
            "schema": {
              "type": "string"
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
            "description": "eventオブジェクトのlistオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/eventList"
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
    "/events/{id}": {
      "get": {
        "summary": "イベント情報を取得",
        "description": "特定のイベント情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "evnt_で始まる一意なオブジェクトを示す文字列",
            "required": true,
            "schema": {
              "type": "string",
              "example": "evnt_54db4d63c7886256acdbc784ccf"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定したidのeventオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/event"
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
      "event": {
        "type": "object",
        "description": "eventオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "evnt_で始まる一意なオブジェクトを示す文字列",
            "example": "evnt_54db4d63c7886256acdbc784ccf"
          },
          "object": {
            "type": "string",
            "description": "\"event\"の固定文字列",
            "example": "event"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "このイベント作成時のUTCタイムスタンプ"
          },
          "type": {
            "type": "string",
            "description": "このイベントのタイプ。値の種類については[こちら](https://pay.jp/docs/webhook#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88)"
          },
          "pending_webhooks": {
            "type": "integer",
            "description": "設定されたURLへの通知が完了していない(2xxのレスポンスが得られていない)webhookの数"
          },
          "data": {
            "type": "object",
            "description": "このイベントに関連したリソースオブジェクト"
          }
        },
        "required": ["id", "object", "livemode", "created", "type", "data"]
      },
      "eventList": {
        "type": "object",
        "description": "eventオブジェクトのリスト",
        "properties": {
          "object": {
            "type": "string",
            "description": "固定値 'list'",
            "example": "list"
          },
          "data": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/event"
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
                "description": "HTTPステータスコードと同様の値が数値型で入ります",
                "enum": [200, 400, 401, 402, 404, 429, 500]
              },
              "type": {
                "type": "string",
                "description": "大まかなエラー種別が入ります",
                "enum": [
                  "client_error",
                  "card_error",
                  "server_error",
                  "not_allowed_method_error",
                  "auth_error",
                  "invalid_request_error"
                ]
              },
              "message": {
                "type": "string",
                "description": "エラーメッセージ。これは事業者向けの内容となっており、エンドユーザーへ提示する内容として利用することは推奨しておりません。"
              },
              "code": {
                "type": "string",
                "description": "詳細なエラー内容の識別子が入ります",
                "enum": [
                  "invalid_number",
                  "invalid_cvc",
                  "invalid_expiration_date",
                  "incorrect_card_data",
                  "invalid_expiry_month",
                  "invalid_expiry_year",
                  "expired_card",
                  "card_declined",
                  "card_flagged",
                  "processing_error",
                  "missing_card",
                  "unacceptable_brand",
                  "invalid_id",
                  "no_api_key",
                  "invalid_api_key",
                  "invalid_plan",
                  "invalid_expiry_days",
                  "unnecessary_expiry_days",
                  "invalid_flexible_id",
                  "invalid_timestamp",
                  "invalid_trial_end",
                  "invalid_string_length",
                  "invalid_country",
                  "invalid_currency",
                  "invalid_address_zip",
                  "invalid_amount",
                  "invalid_plan_amount",
                  "invalid_card",
                  "invalid_card_name",
                  "invalid_card_country",
                  "invalid_card_address_zip",
                  "invalid_card_address_state",
                  "invalid_card_address_city",
                  "invalid_card_address_line",
                  "invalid_customer",
                  "invalid_boolean",
                  "invalid_email",
                  "no_allowed_param",
                  "no_param",
                  "invalid_querystring",
                  "missing_param",
                  "invalid_param_key",
                  "no_payment_method",
                  "payment_method_duplicate",
                  "payment_method_duplicate_including_customer",
                  "failed_payment",
                  "invalid_refund_amount",
                  "already_refunded",
                  "invalid_amount_to_not_captured",
                  "refund_amount_gt_net",
                  "capture_amount_gt_net",
                  "invalid_refund_reason",
                  "already_captured",
                  "cant_capture_refunded_charge",
                  "cant_reauth_refunded_charge",
                  "charge_expired",
                  "already_exist_id",
                  "token_already_used",
                  "already_have_card",
                  "dont_has_this_card",
                  "doesnt_have_card",
                  "already_have_the_same_card",
                  "invalid_interval",
                  "invalid_trial_days",
                  "invalid_billing_day",
                  "billing_day_for_non_monthly_plan",
                  "exist_subscribers",
                  "already_subscribed",
                  "already_canceled",
                  "already_paused",
                  "subscription_worked",
                  "cannot_change_prorate_status",
                  "too_many_metadata_keys",
                  "invalid_metadata_key",
                  "invalid_metadata_value",
                  "apple_pay_disabled_in_livemode",
                  "invalid_apple_pay_token",
                  "test_card_on_livemode",
                  "not_activated_account",
                  "payjp_wrong",
                  "pg_wrong",
                  "not_found",
                  "not_allowed_method",
                  "over_capacity",
                  "refund_limit_exceeded",
                  "cannot_prorated_refund_of_subscription",
                  "three_d_secure_incompleted",
                  "three_d_secure_failed",
                  "not_in_three_d_secure_flow",
                  "unverified_token",
                  "invalid_owner_type"
                ]
              },
              "param": {
                "type": ["string", "null"],
                "description": "エラーに関連するパラメータ名"
              },
              "charge": {
                "type": ["string", "null"],
                "description": "エラーに関連する支払いID"
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
