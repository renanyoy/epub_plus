import '../entities/epub_text_content_file.dart';
import 'epub_content_file_ref.dart';
import 'dart:convert' as convert;

class EpubTextContentFileRef extends EpubContentFileRef {
  EpubTextContentFileRef({
    required super.epubBookRef,
    super.fileName,
    super.contentMimeType,
    super.contentType,
  });

  @override
  int get hashCode =>
      epubBookRef.hashCode ^
      fileName.hashCode ^
      contentMimeType.hashCode ^
      contentType.hashCode;

  @override
  bool operator ==(covariant EpubTextContentFileRef other) {
    if (identical(this, other)) return true;

    return other.epubBookRef == epubBookRef &&
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

  EpubTextContentFile get textContentFile {
    final result = EpubTextContentFile(
      fileName: fileName,
      contentType: contentType,
      contentMimeType: contentMimeType,
      content: asText,
    );
    return result;
  }
}

extension TextContentFiles on Map<String, EpubTextContentFileRef> {
  Map<String, EpubTextContentFile> get textContentFiles =>
      map((k, v) => MapEntry(k, v.textContentFile));
}
