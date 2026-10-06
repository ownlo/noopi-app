class WebConfig {
  WebConfig(String url) : initialUri = Uri.parse(url) {
    if (!isWebUri(initialUri) || initialUri.userInfo.isNotEmpty) {
      throw ArgumentError('NOOPI_WEB_URL must be an absolute HTTP(S) URL.');
    }
  }

  factory WebConfig.fromEnvironment() => WebConfig(
    const String.fromEnvironment(
      'NOOPI_WEB_URL',
      defaultValue: 'https://noopi.kr',
    ),
  );

  final Uri initialUri;

  static bool isWebUri(Uri uri) =>
      (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty;

  bool isInternal(Uri uri) =>
      isWebUri(uri) && uri.userInfo.isEmpty && uri.origin == initialUri.origin;
}
