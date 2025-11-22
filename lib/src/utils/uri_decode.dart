String decodeUri(String href) {
  try {
    return Uri.decodeFull(href);
  } catch (_) {
    return href;
  }
}
