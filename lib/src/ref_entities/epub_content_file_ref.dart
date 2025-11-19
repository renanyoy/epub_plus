import 'dart:typed_data';
import 'package:epub_plus/epub_plus.dart';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';

import '../utils/zip_path_utils.dart';

abstract class EpubContentFileRef {
  final EpubBookRef epubBookRef;
  final String? fileName;
  final EpubContentType? contentType;
  final String? contentMimeType;

  const EpubContentFileRef({
    required this.epubBookRef,
    this.fileName,
    this.contentType,
    this.contentMimeType,
  });

  @override
  int get hashCode {
    return epubBookRef.hashCode ^
        fileName.hashCode ^
        contentType.hashCode ^
        contentMimeType.hashCode;
  }

  @override
  bool operator ==(covariant EpubContentFileRef other) {
    if (identical(this, other)) return true;

    return other.epubBookRef == epubBookRef &&
        other.fileName == fileName &&
        other.contentType == contentType &&
        other.contentMimeType == contentMimeType;
  }

  ArchiveFile get file {
    var contentFilePath = ZipPathUtils.combine(
        epubBookRef.schema!.contentDirectoryPath, fileName);
    var contentFileEntry = epubBookRef.epubArchive.files
        .firstWhereOrNull((ArchiveFile x) => x.name == contentFilePath);
    if (contentFileEntry == null) {
      throw Exception(
          'EPUB parsing error: file $contentFilePath not found in archive.');
    }
    return contentFileEntry;
  }

  Uint8List get content => file.content;
}
