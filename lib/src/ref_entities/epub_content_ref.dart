import 'package:collection/collection.dart';

import '../entities/epub_content.dart';
import '../entities/epub_content_file.dart';
import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef {
  final Map<String, EpubTextContentFileRef> html;
  final Map<String, EpubTextContentFileRef> css;
  final Map<String, EpubByteContentFileRef> images;
  final Map<String, EpubByteContentFileRef> fonts;
  final Map<String, EpubContentFileRef> allFiles;

  const EpubContentRef({
    this.html = const <String, EpubTextContentFileRef>{},
    this.css = const <String, EpubTextContentFileRef>{},
    this.images = const <String, EpubByteContentFileRef>{},
    this.fonts = const <String, EpubByteContentFileRef>{},
    this.allFiles = const <String, EpubContentFileRef>{},
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
    final allFiles = <String, EpubContentFile>{};

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
}
