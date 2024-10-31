local account = import 'paths/account.jsonnet';
local balance = import 'paths/balance.jsonnet';
local charge = import 'paths/charge.jsonnet';
local customer = import 'paths/customer.jsonnet';
local event = import 'paths/event.jsonnet';
local plan = import 'paths/plan.jsonnet';
local statement = import 'paths/statement.jsonnet';
local subscription = import 'paths/subscription.jsonnet';
local tds = import 'paths/tds.jsonnet';
local tenant = import 'paths/tenant.jsonnet';
local term = import 'paths/term.jsonnet';
local token = import 'paths/token.jsonnet';
local errors = import 'components/errors.jsonnet';
local eventType = import 'components/event_type.jsonnet';
local metadata = import 'components/metadata.jsonnet';
local paginations = import 'components/paginations.jsonnet';
local rateLimitError = import 'components/rate_limit.jsonnet';

// componentsSchemas."x-payjpOperations": []
local Custom(path, operation, method_name, method_type='custom') = {
  "method_name": method_name, // like capture
  "method_type": method_type, // like html, ...
  "operation": operation,
  "path": path
};
local Retrieve(path) = Custom(path, 'get', 'retrieve', 'retrieve');
local List(path) = Custom(path, 'get', 'list', 'list');
local Create(path) = Custom(path, 'post', 'create', 'create');
local Update(path) = Custom(path, 'post', 'update', 'update');
local Delete(path) = Custom(path, 'delete', 'delete', 'delete');

local componentsSchemasObj = {[
    Retrieve('/tokens/{token}'),
    Create('/tokens'),
    Retrieve('/terms/{term}'),
    List('/terms'),
]}
local version = '20241101T12'
local url = 'https://pay.jp/docs/api'

{
  "openapi": "3.0.0",
  "info": {
    "title": "PAY.JP API",
    "termsOfService": url,
    "version": version,
    "description": "PAY.JP API (unofficial)",
    "contact": {
      "email": "darai0512@yahoo.co.jp",
      "name": "Daiki Arai"
    }
  },
  "servers": [
    {
      "url": "https://api.pay.jp/v1"
    }
  ],
  paths: account.paths +
    balance.paths +
    charge.paths +
    customer.paths +
    event.paths +
    plan.paths +
    statement.paths +
    subscription.paths +
    tds.paths +
    tenant.paths +
    term.paths +
    token.paths,
  components: {
    schemas:
      account.components.schemas +
      balance.components.schemas +
      charge.components.schemas +
      customer.components.schemas +
      errors.components.schemas +
      event.components.schemas +
      eventType.components.schemas +
      metadata.components.schemas +
      paginations.components.schemas +
      plan.components.schemas +
      statement.components.schemas +
      subscription.components.schemas +
      // tds.components.schemas +
      tenant.components.schemas +
      term.components.schemas +
      token.components.schemas +
      rateLimitError.components.schemas,
  }
}