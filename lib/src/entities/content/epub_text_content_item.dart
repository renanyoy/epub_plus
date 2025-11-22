import 'epub_content_item.dart';

class EpubTextContentItem extends EpubContentItem {
  final String content;

  const EpubTextContentItem({
    super.fileName,
    super.contentMimeType,
    super.contentType,
    required this.content,
  });

  @override
  int get hashCode =>
      fileName.hashCode ^
      contentMimeType.hashCode ^
      contentType.hashCode ^
      content.hashCode;

  @override
  bool operator ==(covariant EpubTextContentItem other) {
    if (identical(this, other)) return true;

    return other.fileName == fileName &&
        other.contentMimeType == contentMimeType &&
        other.contentType == contentType &&
        other.content == content;
  }
}
