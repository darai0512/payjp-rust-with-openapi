{
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
            "description": "このイベントのタイプ",
            "enum": [
              "charge.succeeded",
              "charge.failed",
              "charge.updated",
              "charge.refunded",
              "charge.captured",
              "dispute.created",
              "token.created",
              "customer.created",
              "customer.updated",
              "customer.deleted",
              "customer.card.created",
              "customer.card.updated",
              "customer.card.deleted",
              "plan.created",
              "plan.updated",
              "plan.deleted",
              "subscription.created",
              "subscription.updated",
              "subscription.deleted",
              "subscription.paused",
              "subscription.resumed",
              "subscription.canceled",
              "subscription.renewed",
              "transfer.succeeded",
              "tenant.created",
              "tenant.deleted",
              "tenant.updated",
              "tenant_transfer.succeeded",
              "term.created",
              "term.closed",
              "statement.created",
              "balance.created",
              "balance.fixed",
              "balance.closed",
              "balance.merged"
            ]
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
      }
    }
  }
}
