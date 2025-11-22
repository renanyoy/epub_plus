import 'dart:typed_data';
import 'package:epub_plus/epub_plus.dart';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';

import '../../utils/zip_path_utils.dart';

abstract class EpubContentItemRef {
  final EpubBookRef bookRef;
  final String? fileName;
  final EpubContentType? contentType;
  final String? contentMimeType;

  const EpubContentItemRef({
    required this.bookRef,
    this.fileName,
    this.contentType,
    this.contentMimeType,
  });

  @override
  int get hashCode {
    return bookRef.hashCode ^
        fileName.hashCode ^
        contentType.hashCode ^
        contentMimeType.hashCode;
  }

  @override
  bool operator ==(covariant EpubContentItemRef other) {
    if (identical(this, other)) return true;

    return other.bookRef == bookRef &&
        other.fileName == fileName &&
        other.contentType == contentType &&
        other.contentMimeType == contentMimeType;
  }

  ArchiveFile get file {
    var contentFilePath = ZipPathUtils.combine(
        bookRef.schema!.contentDirectoryPath, fileName);
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
        fileName: fileName,
        contentType: contentType,
        contentMimeType: contentMimeType,
        content: content,
      );
}

extension ByteContentFiles on Map<String, EpubContentItemRef> {
  Map<String, EpubByteContentItem> get byteContentFiles =>
      map((k, v) => MapEntry(k, v.byteContentFile));
}
