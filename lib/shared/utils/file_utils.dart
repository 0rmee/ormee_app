class FileUtil {
  static bool isImageFile(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }

  static bool isPdfFile(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  static bool isVideoFile(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi');
  }
}