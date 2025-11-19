import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:image/image.dart';

import 'epub_content_file.dart';

class EpubByteContentFile extends EpubContentFile {
  final Uint8List content;
  const EpubByteContentFile({
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
      const DeepCollectionEquality().hash(content);

  @override
  bool operator ==(covariant EpubByteContentFile other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return fileName == other.fileName &&
        contentMimeType == other.contentMimeType &&
        contentType == other.contentType &&
        listEquals(content, other.content);
  }

  Image? get asImage => decodeImage(content);
}
