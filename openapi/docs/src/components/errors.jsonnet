{
  "components": {
    "schemas": {
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