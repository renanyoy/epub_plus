import 'package:collection/collection.dart' show IterableExtension;
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/readers/content_reader.dart';

import '../ref_entities/content/epub_byte_content_item_ref.dart';

extension BookCoverReaderExt on EpubBookRef {
  EpubByteContentFileRef? get coverContent {
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
      coverManifestItem = schema?.package?.manifest?.items.firstWhereOrNull(
          (manifestItem) => manifestItem.id?.toLowerCase() == coverId);
      coverManifestItem ??= schema?.package?.manifest?.items.firstWhereOrNull(
          (manifestItem) =>
              manifestItem.id?.toLowerCase().endsWith(coverId) ?? false);
      coverManifestItem ??= schema?.package?.manifest?.items.firstWhereOrNull(
          (manifestItem) =>
              manifestItem.id?.toLowerCase().contains(coverId) ?? false);
    }
    if (coverManifestItem == null) {
      throw Exception(
        'Incorrect EPUB manifest: item with ID = "${coverMetaItem.content}" is missing.',
      );
    }

    if (!content.images.containsKey(coverManifestItem.href)) {
      throw Exception(
        'Incorrect EPUB manifest: item with href = "${coverManifestItem.href}" is missing.',
      );
    }

    return content.images[coverManifestItem.href];
  }

  
}
