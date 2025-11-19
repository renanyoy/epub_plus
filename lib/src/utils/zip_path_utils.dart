class ZipPathUtils {
  static String getDirectoryPath(String filePath) {
    var lastSlashIndex = filePath.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return '';
    } else {
      return filePath.substring(0, lastSlashIndex);
    }
  }

  static String? combine(String? directory, String? fileName) {
    if (directory == null || directory == '') {
      return fileName;
    } else if (fileName != null) {
      while (fileName!.startsWith('../') || fileName.startsWith('./')) {
        if (fileName.startsWith('./')) {
          fileName = fileName.substring(2);
        } else {
          fileName = fileName.substring(3);
          final di = directory!.lastIndexOf('/');
          if (di < 0) return fileName;
          directory = directory.substring(0, di);
        }
      }
      return '$directory/$fileName';
    }
    return null;
  }
}
