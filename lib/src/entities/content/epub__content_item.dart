import 'epub__content_type.dart';

abstract class EpubContentItem {
  final String? fileName;
  final EpubContentType? contentType;
  final String? contentMimeType;

  const EpubContentItem({
    this.fileName,
    this.contentType,
    this.contentMimeType,
  });

  @override
  int get hashCode =>
      fileName.hashCode ^ contentType.hashCode ^ contentMimeType.hashCode;

  @override
  bool operator ==(covariant EpubContentItem other) {
    if (identical(this, other)) return true;

    return other.fileName == fileName &&
        other.contentType == contentType &&
        other.contentMimeType == contentMimeType;
  }

  @override
  String toString() => 'EpubContentFile(fileName: $fileName, contentType: $contentType, contentMimeType: $contentMimeType)';
}
