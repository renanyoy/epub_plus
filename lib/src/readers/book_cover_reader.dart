import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/readers/content_reader.dart';
import 'package:image/image.dart' as images;

import '../ref_entities/epub_byte_content_file_ref.dart';

extension BookCoverReaderExt on EpubBookRef {
  Future<images.Image?> get coverImage async {
    final metaItems = schema?.package?.metadata?.metaItems;
    if (metaItems == null || metaItems.isEmpty) return null;

    final coverMetaItem = metaItems.firstWhereOrNull((metaItem) =>
        metaItem.name != null && metaItem.name!.toLowerCase() == 'cover');
    if (coverMetaItem == null) return null;
    if (coverMetaItem.content == null || coverMetaItem.content!.isEmpty) {
      throw Exception(
        'Incorrect EPUB metadata: cover item content is missing.',
      );
    }

    final coverId = coverMetaItem.content?.toLowerCase();
    EpubManifestItem? coverManifestItem;
    if (coverId != null) {
      coverManifestItem = schema?.package?.manifest?.items
          .firstWhereOrNull(
              (manifestItem) => manifestItem.id?.toLowerCase() == coverId);
      coverManifestItem ??= schema?.package?.manifest?.items
          .firstWhereOrNull((manifestItem) =>
              manifestItem.id?.toLowerCase().endsWith(coverId) ?? false);
    }
    if (coverManifestItem == null) {
      throw Exception(
        'Incorrect EPUB manifest: item with ID = "${coverMetaItem.content}" is missing.',
      );
    }

    EpubByteContentFileRef? coverImageContentFileRef;
    if (!content.images.containsKey(coverManifestItem.href)) {
      throw Exception(
        'Incorrect EPUB manifest: item with href = "${coverManifestItem.href}" is missing.',
      );
    }

    coverImageContentFileRef = content.images[coverManifestItem.href];
    var coverImageContent =
        await coverImageContentFileRef!.readContentAsBytes();
    var retval = images.decodeImage(Uint8List.fromList(coverImageContent));
    return retval;
  }
}
