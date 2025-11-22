import '../../entities/content/epub__content_type.dart';
import '../../entities/content/epub_text_content_item.dart';
import '../epub_book_ref.dart';
import 'epub__content_item_ref.dart';
import 'dart:convert' as convert;

class EpubTextContentItemRef extends EpubContentItemRef {
  EpubTextContentItemRef({
    required super.bookRef,
    required super.filename,
    required super.mimeType,
  });

  @override
  int get hashCode =>
      bookRef.hashCode ^ filename.hashCode ^ mimeType.hashCode;

  @override
  bool operator ==(covariant EpubTextContentItemRef other) {
    if (identical(this, other)) return true;

    return other.bookRef == bookRef &&
        other.filename == filename &&
        other.mimeType == mimeType;
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
      filename: filename,
      mimeType: mimeType,
      contentType: EpubContentType.fromMimeType(mimeType),
      content: asText,
    );
    return result;
  }

  EpubTextContentItemRef copyWith({
    EpubBookRef? bookRef,
    String? mimeType,
    String? filename,
  }) {
    return EpubTextContentItemRef(
      bookRef: bookRef ?? this.bookRef,
      mimeType: mimeType ?? this.mimeType,
      filename: filename ?? this.filename,
    );
  }
}

extension TextContentFiles on Map<String, EpubTextContentItemRef> {
  Map<String, EpubTextContentItem> get textContentFiles =>
      map((k, v) => MapEntry(k, v.textContentFile));
}
