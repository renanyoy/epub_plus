import 'epub__content_item.dart';

class EpubTextContentItem extends EpubContentItem {
  final String content;

  const EpubTextContentItem({
    required super.filename,
    required super.mimeType,
    required super.contentType,
    required this.content,
  });

  @override
  int get hashCode =>
      filename.hashCode ^
      mimeType.hashCode ^
      contentType.hashCode ^
      content.hashCode;

  @override
  bool operator ==(covariant EpubTextContentItem other) {
    if (identical(this, other)) return true;

    return other.filename == filename &&
        other.mimeType == mimeType &&
        other.contentType == contentType &&
        other.content == content;
  }
}
