local account = import './account.json';
local balance = import './balance.json';
local charge = import './charge.json';
local customer = import 'customer.json';
local event = import 'event.json';
local plan = import './plan.json';
local statement = import 'statement.json';
local subscription = import 'subscription.json';
local tds = import 'tds.json';
local tenant = import 'tenant.json';
local term = import './term.json';
local tdsr = import './three_d_secure_request.json';
local token = import 'token.json';

local base = import './base.json'; /* todo error rate_limit */
local f = import './common.jsonnet';

local json = std.manifestJsonMinified(std.mergePatch(base, {
  paths: account.paths +
    balance.paths +
    charge.paths +
    customer.paths +
    event.paths +
    plan.paths +
    statement.paths +
    subscription.paths +
    tds.paths +
    tdsr.paths +
    tenant.paths +
    term.paths +
    token.paths,
  components: {
    schemas:
      std.mergePatch(account.components.schemas, {
        account: {
          "x-operations": [
            f.Retrieve("/accounts"),
          ]
        }
      }) +
      std.mergePatch(balance.components.schemas, {
        balance: {
          "x-operations": [
            f.List("/balances"),
            f.Retrieve("/balances/{balance}"),
            f.Custom("/balances/{balance}/statement_urls", "post", "statementUrls"),
          ]
        }
      }) +
      std.mergePatch(charge.components.schemas, {
        charge: {
          "x-operations": [
            f.List("/charges"),
            f.Create("/charges"),
            f.Retrieve("/charges/{charge}"),
            f.Update("/charges/{charge}"),
            f.Custom("/charges/{charge}/tds_finish", "post", "tdsFinish"),
            f.Custom("/charges/{charge}/refund", "post", "refund"),
            f.Custom("/charges/{charge}/reauth", "post", "reauth"),
            f.Custom("/charges/{charge}/capture", "post", "capture"),
          ]
        }
      }) +
      std.mergePatch(customer.components.schemas, {
        customer: {
          "x-operations": [
            f.List("/customers"),
            f.Create("/customers"),
            f.Retrieve("/customers/{customer}"),
            f.Update("/customers/{customer}"),
            f.Delete("/customers/{customer}"),
            f.List("/customers/{customer}/cards"),
            f.Create("/customers/{customer}/cards"),
            f.Retrieve("/customers/{customer}/cards/{card}"),
            f.Update("/customers/{customer}/cards/{card}"),
            f.Delete("/customers/{customer}/cards/{card}"),
            // f.List("/customers/{customer}/subscriptions"),
            // f.Retrieve("/customers/{customer}/subscriptions/{subscription}"),
          ]
        }
      }) +
      std.mergePatch(event.components.schemas, {
        event: {
          "x-operations": [
            f.List("/events"),
            f.Retrieve("/events/{event}"),
          ]
        }
      }) +
      std.mergePatch(plan.components.schemas, {
        plan: {
          "x-operations": [
            f.List("/plans"),
            f.Retrieve("/plans/{plan}"),
          ]
        }
      }) +
      std.mergePatch(statement.components.schemas, {
        statement: {
          "x-operations": [
            f.List("/statements"),
            f.Retrieve("/statements/{statement}"),
            f.Custom("/statements/{statement}/statement_urls", "post", "statementUrls"),
          ]
        }
      }) +
      std.mergePatch(subscription.components.schemas, {
        subscription: {
          "x-operations": [
            f.List("/subscriptions"),
            f.Create("/subscriptions"),
            f.Retrieve("/subscriptions/{subscription}"),
            f.Update("/subscriptions/{subscription}"),
            f.Delete("/subscriptions/{subscription}"),
            f.Custom("/subscriptions/{subscription}/pause", "post", "pause"),
            f.Custom("/subscriptions/{subscription}/resume", "post", "resume"),
            f.Custom("/subscriptions/{subscription}/cancel", "post", "cancel"),
          ]
        }
      }) +
      std.mergePatch(tenant.components.schemas, {
        tenant: {
          "x-operations": [
            f.List("/tenants"),
            f.Create("/tenants"),
            f.Retrieve("/tenants/{tenant}"),
            f.Update("/tenants/{tenant}"),
            f.Delete("/tenants/{tenant}"),
            f.Custom("/tenants/{tenant}/application_urls", "post", "applicationUrls"),
          ]
        }
      }) +
      std.mergePatch(term.components.schemas, {
        term: {
          "x-operations": [
            f.List("/terms"),
            f.Retrieve("/terms/{term}"),
          ]
        }
      }) +
      std.mergePatch(tdsr.components.schemas, {
        three_d_secure_request: {
          "x-operations": [
            f.List("/three_d_secure_requests"),
            f.Create("/three_d_secure_requests"),
            f.Retrieve("/three_d_secure_requests/{three_d_secure_request}"),
          ]
        }
      }) +
      std.mergePatch(token.components.schemas, {
        token: {
          "x-operations": [
            f.Create("/tokens"),
            f.Retrieve("/tokens/{token}"),
          ]
        }
      })
  }
}));

/* todo 処理がすごく遅い。node.jsに変えた方がいい */
std.parseJson(std.strReplace(
std.strReplace(std.strReplace(json, '"./base.json#', '"#'), '"./customer.json#', '"#')
, '"./subscription.json#', '"#'))
