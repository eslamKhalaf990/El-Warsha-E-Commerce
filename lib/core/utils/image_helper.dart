class ImageHelper {
  /// Extracts the file ID from Google Drive URLs or generic URLs containing an 'id' parameter.
  /// Handles formats such as:
  /// - `https://drive.google.com/uc?export=view&id=<id>`
  /// - `https://drive.google.com/file/d/<id>/view`
  /// - `https://...?...id=<id>...`
  static String? extractFileId(String? url) {
    if (url == null || url.trim().isEmpty) return null;

    try {
      final uri = Uri.parse(url.trim());

      // 1. Check if 'id' parameter exists in query string
      if (uri.queryParameters.containsKey('id')) {
        final id = uri.queryParameters['id'];
        if (id != null && id.isNotEmpty) {
          return id;
        }
      }

      // 2. Handle Google Drive path format: /file/d/<id>/view or /d/<id>
      final regex = RegExp(r'/d/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(uri.path);
      if (match != null) {
        return match.group(1);
      }
    } catch (_) {
      // Invalid URL format
    }
    return null;
  }
}
