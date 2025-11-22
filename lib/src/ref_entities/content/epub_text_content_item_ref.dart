import '../../entities/content/epub_content_type.dart';
import '../../entities/content/epub_text_content_item.dart';
import '../epub_book_ref.dart';
import 'epub_content_item_ref.dart';
import 'dart:convert' as convert;

class EpubTextContentItemRef extends EpubContentItemRef {
  EpubTextContentItemRef({
    required super.bookRef,
    super.fileName,
    super.contentMimeType,
    super.contentType,
  });

  @override
  int get hashCode =>
      bookRef.hashCode ^
      fileName.hashCode ^
      contentMimeType.hashCode ^
      contentType.hashCode;

  @override
  bool operator ==(covariant EpubTextContentItemRef other) {
    if (identical(this, other)) return true;

    return other.bookRef == bookRef &&
        other.fileName == fileName &&
        other.contentMimeType == contentMimeType &&
        other.contentType == contentType;
  }

  String get asText {
    try {
      return convert.utf8.decode(content);
    } catch (_) {
      try {
        return convert.ascii.decode(content);
      } catch (_) {}
    }
    return '';
  }

  EpubTextContentItem get textContentFile {
    final result = EpubTextContentItem(
      fileName: fileName,
      contentType: contentType,
      contentMimeType: contentMimeType,
      content: asText,
    );
    return result;
  }

  EpubTextContentItemRef copyWith({
    EpubBookRef? bookRef,
    String? contentMimeType,
    EpubContentType? contentType,
    String? fileName,
  }) {
    return EpubTextContentItemRef(
      bookRef: bookRef ?? this.bookRef,
      contentMimeType: contentMimeType ?? this.contentMimeType,
      contentType: contentType ?? this.contentType,
      fileName: fileName ?? this.fileName,
    );
  }
}

extension TextContentFiles on Map<String, EpubTextContentItemRef> {
  Map<String, EpubTextContentItem> get textContentFiles =>
      map((k, v) => MapEntry(k, v.textContentFile));
}
