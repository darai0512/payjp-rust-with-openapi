{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "version": "1.0.0",
    "description": "PAY.JP Subscription API specification in OpenAPI 3.0"
  },
  "paths": {
    "/subscriptions": {
      "post": {
        "summary": "定期課金を作成",
        "description": "顧客IDとプランIDを指定して、定期課金を開始します。\n\n前払い式のため、定期課金作成時に最初の課金が実行されます。但し以下の場合には作成時の課金はされません。\n\n- トライアル状態(`status=trial`)で作成された場合\n- プランの課金日(`billing_day`)が指定され、定期課金の日割り設定(`prorate`)が設定されていない場合",
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/subscriptionCreateRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "作成されたsubscriptionオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscription"
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
        "summary": "定期課金のリストを取得",
        "description": "生成した定期課金のリストを取得します。\n\nリストは、直近で生成された順番に取得されます。",
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
            "name": "plan",
            "in": "query",
            "description": "絞り込みたいプランID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "customer",
            "in": "query",
            "description": "絞り込みたい顧客ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "status",
            "in": "query",
            "description": "定期課金ステータス。`active`, `trial`, `canceled` または `paused` のみ指定可能。",
            "schema": {
              "type": "string",
              "enum": ["active", "trial", "canceled", "paused"]
            }
          }
        ],
        "responses": {
          "200": {
            "description": "subscriptionオブジェクトのlistオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscriptionList"
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
    "/subscriptions/{id}": {
      "get": {
        "summary": "定期課金情報を取得",
        "description": "指定されたIDの定期課金情報を取得します。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "定期課金ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "sub_567a1e44562932ec1a7682d746e0"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "指定されたidのsubscriptionオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscription"
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
        "summary": "定期課金を更新",
        "description": "トライアル期間を新たに設定したり、プランの変更を行うことができます。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "定期課金ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "sub_567a1e44562932ec1a7682d746e0"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/subscriptionUpdateRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "更新されたsubscriptionオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscription"
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
        "summary": "定期課金を削除",
        "description": "定期課金をすぐに削除します。\n次回以降の課金は行われず、一度削除した定期課金は再び戻すことができません。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "定期課金ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "sub_19f6a2123363b514a743d1334109"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/subscriptionDeleteRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "削除結果",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscriptionDeleteResponse"
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
    "/subscriptions/{id}/pause": {
      "post": {
        "summary": "定期課金を停止",
        "description": "引き落としの失敗やカードが不正である、また定期課金を停止したい場合はこのリクエストで定期購入を停止させます。\n\n定期課金を停止させると、再開されるまで引き落とし処理は一切行われません。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "定期課金ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "sub_f9fb5ef2507b46c00a1a84c47bed"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "停止されたsubscriptionオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscription"
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
    "/subscriptions/{id}/resume": {
      "post": {
        "summary": "定期課金を再開",
        "description": "停止もしくはキャンセル状態(`status=canceled or paused`)の定期課金を再開させます。\n\nトライアル期間中であればトライアル状態(`status=trial`)で再開します。\n\n再開時の `current_period_end` が過去の日時の場合、トライアル期間内でなければ支払いが行われ、その時点が周期の開始として設定されます。\n支払いの失敗により停止していた場合などは、 `current_period_end` は支払い失敗時の値になるため、必ず過去の日時がセットされます。\n\n再開時の支払いに失敗すると、定期課金は再開されません。\nこの場合は、有効なカードを顧客のデフォルトカードにセットしてから、再度定期課金の再開を行ってください。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "定期課金ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "sub_f9fb5ef2507b46c00a1a84c47bed"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {
              "schema": {
                "$ref": "#/components/schemas/subscriptionResumeRequest"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "再開されたsubscriptionオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscription"
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
    "/subscriptions/{id}/cancel": {
      "post": {
        "summary": "定期課金をキャンセル",
        "description": "定期課金をキャンセルし、現在の周期の終了日をもって定期課金を終了させます。\n\n終了日以前であれば、定期課金の再開リクエスト(/resume)を行うことで、キャンセルを取り消すことができます。\n終了日をむかえた定期課金は自動的に削除されますのでご注意ください。",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "定期課金ID",
            "required": true,
            "schema": {
              "type": "string",
              "example": "sub_19f6a2123363b514a743d1334109"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "キャンセルされたsubscriptionオブジェクト",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/subscription"
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
      "subscription": {
        "type": "object",
        "description": "subscriptionオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "`sub_`で始まる一意なオブジェクトを示す文字列",
            "example": "sub_567a1e44562932ec1a7682d746e0"
          },
          "object": {
            "type": "string",
            "description": "\"subscription\"の固定文字列",
            "example": "subscription"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          },
          "created": {
            "type": "integer",
            "format": "int64",
            "description": "定期課金作成時のタイムスタンプ"
          },
          "start": {
            "type": "integer",
            "format": "int64",
            "description": "定期課金開始時のタイムスタンプ"
          },
          "customer": {
            "type": "string",
            "description": "定期課金を購読している顧客ID"
          },
          "plan": {
            "$ref": "#/components/schemas/plan"
          },
          "next_cycle_plan": {
            "oneOf": [
              {
                "$ref": "#/components/schemas/plan"
              },
              {
                "type": "null"
              }
            ],
            "description": "次回サイクル更新時に指定のプランへと自動的に切り替えし、課金を試みます。"
          },
          "status": {
            "type": "string",
            "description": "`trial`, `active`, `canceled` または `paused` のいずれかの値。",
            "enum": ["trial", "active", "canceled", "paused"]
          },
          "prorate": {
            "type": "boolean",
            "description": "日割り課金が有効かどうか"
          },
          "current_period_start": {
            "type": "integer",
            "format": "int64",
            "description": "現在の購読期間開始時のタイムスタンプ"
          },
          "current_period_end": {
            "type": "integer",
            "format": "int64",
            "description": "現在の購読期間終了時のタイムスタンプ"
          },
          "trial_start": {
            "type": "integer", "nullable": true,
            "format": "int64",
            "description": "トライアル期間開始時のタイムスタンプ"
          },
          "trial_end": {
            "type": "integer", "nullable": true,
            "format": "int64",
            "description": "トライアル期間終了時のタイムスタンプ"
          },
          "paused_at": {
            "type": "integer", "nullable": true,
            "format": "int64",
            "description": "定期課金が停止状態になった時のタイムスタンプ"
          },
          "canceled_at": {
            "type": "integer", "nullable": true,
            "format": "int64",
            "description": "定期課金がキャンセル状態になった時のタイムスタンプ"
          },
          "resumed_at": {
            "type": "integer", "nullable": true,
            "format": "int64",
            "description": "停止またはキャンセル状態の定期課金が有効状態になった時のタイムスタンプ"
          },
          "metadata": {
            "type": "object", "nullable": true,
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["id", "object", "livemode", "created", "start", "customer", "plan", "status", "prorate", "current_period_start", "current_period_end"]
      },
      "plan": {
        "type": "object",
        "description": "planオブジェクト",
        "properties": {
          "id": {
            "type": "string",
            "description": "`pln_`で始まる一意なオブジェクトを示す文字列",
            "example": "pln_9589006d14aad86aafeceac06b60"
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
            "description": "プラン作成時のタイムスタンプ"
          },
          "amount": {
            "type": "integer",
            "description": "プランの料金"
          },
          "currency": {
            "type": "string",
            "description": "3文字のISOコード(現状 \"jpy\" のみサポート)",
            "example": "jpy"
          },
          "interval": {
            "type": "string",
            "description": "課金の間隔。`day`, `week`, `month`, `year` のいずれか。",
            "enum": ["day", "week", "month", "year"]
          },
          "name": {
            "type": "string",
            "description": "プラン名"
          },
          "trial_days": {
            "type": "integer",
            "description": "トライアル期間の日数"
          },
          "billing_day": {
            "type": "integer", "nullable": true,
            "description": "課金日。1から31の整数で指定可能。nullの場合は課金日を指定しない。"
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["id", "object", "livemode", "created", "amount", "currency", "interval", "name", "trial_days"]
      },
      "subscriptionCreateRequest": {
        "type": "object",
        "properties": {
          "customer": {
            "type": "string",
            "description": "顧客ID"
          },
          "plan": {
            "type": "string",
            "description": "プランID"
          },
          "trial_end": {
            "type": ["integer", "string"],
            "description": "リクエスト時より未来のタイムスタンプ(5年後まで) or 文字列 `now` が指定可能です。"
          },
          "prorate": {
            "type": "boolean",
            "description": "`true`の場合、日割り課金を設定します"
          },
          "metadata": {
            "type": "object",
            "description": "キーバリューの任意データ",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": ["customer", "plan"]
      },
      "subscriptionUpdateRequest": {
        "type": "object",
        "properties": {
          "trial_end": {
            "type": ["integer", "string"],
            "description": "リクエスト時より未来のタイムスタンプ(5年後まで) or 文字列 `now` が指定可能です。"
          },
          "plan": {
            "type": "string",
            "description": "新しいプランのID"
          },
          "prorate": {
            "type": "boolean",
            "description": "`true`の場合、日割り課金を設定します"
          },
          "next_cycle_plan": {
            "type": "string",
            "description": "次回サイクル更新時に指定のプランへと自動的に切り替えを行い課金を試みます。"
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
      "subscriptionResumeRequest": {
        "type": "object",
        "properties": {
          "trial_end": {
            "type": ["integer", "string"],
            "description": "リクエスト時より未来のタイムスタンプ(5年後まで) or 文字列 `now` が指定可能です。"
          },
          "prorate": {
            "type": "boolean",
            "description": "`true`の場合、日割り課金を設定します"
          }
        }
      },
      "subscriptionDeleteRequest": {
        "type": "object",
        "properties": {
          "prorate": {
            "type": "boolean",
            "description": "`true`の場合、削除時から現在の周期の終了日までの日割り分を算出し、返金処理を行います。"
          }
        }
      },
      "subscriptionDeleteResponse": {
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
            "example": "sub_19f6a2123363b514a743d1334109"
          },
          "livemode": {
            "type": "boolean",
            "description": "本番環境かどうか"
          }
        },
        "required": ["deleted", "id", "livemode"]
      },
      "subscriptionList": {
        "type": "object",
        "description": "subscriptionオブジェクトのlistオブジェクト",
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
