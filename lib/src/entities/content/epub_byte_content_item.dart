import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:image/image.dart';

import 'epub__content_item.dart';

class EpubByteContentItem extends EpubContentItem {
  final Uint8List content;
  const EpubByteContentItem({
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
      const DeepCollectionEquality().hash(content);

  @override
  bool operator ==(covariant EpubByteContentItem other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return filename == other.filename &&
        mimeType == other.mimeType &&
        contentType == other.contentType &&
        listEquals(content, other.content);
  }

  Image? get asImage => decodeImage(content);
}
