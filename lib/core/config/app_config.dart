abstract final class AppConfig {
  /// UUID del proyecto en el backend.
  static const String projectUuid = 'fccd9f53-b046-4fb3-b63a-e3803db4e49f';

  /// URL base de la API REST.
  static const String baseUrl = 'https://aegis.hefesto2js.com/api';

  /// URL base para assets de imágenes (thumbnails, fotos, etc.).
  static const String storageUrl = 'https://aegis.hefesto2js.com/storage';

  /// Versión visible de la app. Mantener sincronizado con pubspec.yaml.
  static const String appVersion = 'v1.0.2';
}
