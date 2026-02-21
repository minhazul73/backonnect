class ApiEndpoint {
  ApiEndpoint._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';

  // Items
  static const String items = '/items';
  static const String itemsBulkImport = '/items/bulk/import';

  static String itemById(int id) => '/items/$id';
}
