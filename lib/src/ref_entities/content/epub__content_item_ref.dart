import 'dart:typed_data';
import 'package:epub_plus/epub_plus.dart';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';

import '../../utils/zip_path_utils.dart';

abstract class EpubContentItemRef {
  final EpubBookRef bookRef;
  final String filename;
  final String mimeType;

  const EpubContentItemRef({
    required this.bookRef,
    required this.filename,
    required this.mimeType,
  });

  @override
  int get hashCode {
    return bookRef.hashCode ^
        filename.hashCode ^
        mimeType.hashCode;
  }

  @override
  bool operator ==(covariant EpubContentItemRef other) {
    if (identical(this, other)) return true;
    return other.bookRef == bookRef &&
        other.filename == filename &&
        other.mimeType == mimeType;
  }

  ArchiveFile get file {
    var contentFilePath = ZipPathUtils.combine(
        bookRef.schema!.contentDirectoryPath, filename);
    var contentFileEntry = bookRef.archive.files
        .firstWhereOrNull((ArchiveFile x) => x.name == contentFilePath);
    if (contentFileEntry == null) {
      throw Exception(
          'EPUB parsing error: file $contentFilePath not found in archive.');
    }
    return contentFileEntry;
  }

  Uint8List get content => file.content;

  EpubByteContentItem get byteContentFile => EpubByteContentItem(
        filename: filename,
        mimeType: mimeType,
        contentType: EpubContentType.fromMimeType(mimeType),
        content: content,
      );
}

extension ByteContentFiles on Map<String, EpubContentItemRef> {
  Map<String, EpubByteContentItem> get byteContentFiles =>
      map((k, v) => MapEntry(k, v.byteContentFile));
}
