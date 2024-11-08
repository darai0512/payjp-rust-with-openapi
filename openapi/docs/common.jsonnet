local Custom(path, operation, method_name, method_type='custom') = {
  "method_name": method_name, // like capture
  "method_type": method_type, // like html, ...
  "operation": operation,
  "path": path
};

{
  Retrieve(path): Custom(path, 'get', 'retrieve', 'retrieve'),
  List(path): Custom(path, 'get', 'list', 'list'),
  Create(path): Custom(path, 'post', 'create', 'create'),
  Update(path): Custom(path, 'post', 'update', 'update'),
  Delete(path): Custom(path, 'delete', 'delete', 'delete'),
  Custom: Custom,
}