import 'package:collection/collection.dart';

import '../entities/epub_content.dart';
import '../entities/content/epub_content_item.dart';
import 'content/epub_byte_content_item_ref.dart';
import 'content/epub_content_item_ref.dart';
import 'content/epub_text_content_item_ref.dart';

class EpubContentRef {
  final Map<String, EpubTextContentItemRef> html;
  final Map<String, EpubTextContentItemRef> css;
  final Map<String, EpubByteContentFileRef> images;
  final Map<String, EpubByteContentFileRef> fonts;
  final Map<String, EpubContentItemRef> allFiles;

  const EpubContentRef({
    this.html = const <String, EpubTextContentItemRef>{},
    this.css = const <String, EpubTextContentItemRef>{},
    this.images = const <String, EpubByteContentFileRef>{},
    this.fonts = const <String, EpubByteContentFileRef>{},
    this.allFiles = const <String, EpubContentItemRef>{},
  });

  @override
  int get hashCode {
    final hash = const DeepCollectionEquality().hash;
    return hash(html) ^ hash(css) ^ hash(images) ^ hash(fonts) ^ hash(allFiles);
  }

  @override
  bool operator ==(covariant EpubContentRef other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return mapEquals(other.html, html) &&
        mapEquals(other.css, css) &&
        mapEquals(other.images, images) &&
        mapEquals(other.fonts, fonts) &&
        mapEquals(other.allFiles, allFiles);
  }

  EpubContent get content {
    final html = this.html.textContentFiles;
    final css = this.css.textContentFiles;
    final images = this.images.byteContentFiles;
    final fonts = this.fonts.byteContentFiles;
    final allFiles = <String, EpubContentItem>{};

    html.forEach((key, value) => allFiles[key] = value);
    css.forEach((key, value) => allFiles[key] = value);
    images.forEach((key, value) => allFiles[key] = value);
    fonts.forEach((key, value) => allFiles[key] = value);

    for (final e in [
      ...this.allFiles.entries.where((e) => !allFiles.containsKey(e.key))
    ]) {
      allFiles[e.key] = e.value.byteContentFile;
    }
    return EpubContent(
      html: html,
      css: css,
      images: images,
      fonts: fonts,
      allFiles: allFiles,
    );
  }

  String debugInfo() {
    final s = StringBuffer();
    for (final key in allFiles.keys) {
      s.writeln(key);
    }
    return s.toString();
  }
}
