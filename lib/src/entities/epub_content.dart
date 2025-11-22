import 'package:collection/collection.dart';

import 'content/epub_byte_content_item.dart';
import 'content/epub_content_item.dart';
import 'content/epub_text_content_item.dart';

class EpubContent {
  final Map<String, EpubTextContentItem> html;
  final Map<String, EpubTextContentItem> css;
  final Map<String, EpubByteContentItem> images;
  final Map<String, EpubByteContentItem> fonts;
  final Map<String, EpubContentItem> allFiles;

  const EpubContent({
    this.html = const <String, EpubTextContentItem>{},
    this.css = const <String, EpubTextContentItem>{},
    this.images = const <String, EpubByteContentItem>{},
    this.fonts = const <String, EpubByteContentItem>{},
    this.allFiles = const <String, EpubContentItem>{},
  });

  @override
  int get hashCode {
    final hash = const DeepCollectionEquality().hash;
    return hash(html) ^ hash(css) ^ hash(images) ^ hash(fonts) ^ hash(allFiles);
  }

  @override
  bool operator ==(covariant EpubContent other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return mapEquals(other.html, html) &&
        mapEquals(other.css, css) &&
        mapEquals(other.images, images) &&
        mapEquals(other.fonts, fonts) &&
        mapEquals(other.allFiles, allFiles);
  }

  T? find<T extends EpubContentItem>({required String href}) {
    T? file = allFiles.entries
        .where((e) => e.value is T)
        .firstWhereOrNull((e) => e.key == href)
        ?.value as T?;
    file ??= allFiles.entries
        .whereType()
        .where((e) => e.value is T)
        .firstWhereOrNull((e) => e.key.endsWith(href))
        ?.value as T?;
    file ??= allFiles.entries
        .where((e) => e.value is T)
        .firstWhereOrNull((e) => e.key.contains(href))
        ?.value as T?;
    return file;
  }

  String debugInfo() {
    final s = StringBuffer();
    for (final key in allFiles.keys) {
      s.writeln(key);
    }
    return s.toString();
  }
}
