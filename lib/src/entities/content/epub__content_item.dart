import 'epub__content_type.dart';

abstract class EpubContentItem {
  final String filename;
  final EpubContentType contentType;
  final String mimeType;

  const EpubContentItem({
    required this.filename,
    required this.contentType,
    required this.mimeType,
  });

  @override
  int get hashCode =>
      filename.hashCode ^ contentType.hashCode ^ mimeType.hashCode;

  @override
  bool operator ==(covariant EpubContentItem other) {
    if (identical(this, other)) return true;

    return other.filename == filename &&
        other.contentType == contentType &&
        other.mimeType == mimeType;
  }

  @override
  String toString() => 'EpubContentFile(fileName: $filename, contentType: $contentType, contentMimeType: $mimeType)';
}
