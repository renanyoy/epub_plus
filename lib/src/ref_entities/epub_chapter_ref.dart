import 'package:collection/collection.dart';

import '../entities/epub_chapter.dart';
import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  final EpubTextContentFileRef? epubTextContentFileRef;
  final String? title;
  final String? anchor;
  final List<EpubChapterRef> subChapters;

  const EpubChapterRef({
    this.epubTextContentFileRef,
    this.title,
    this.anchor,
    this.subChapters = const <EpubChapterRef>[],
  });

  @override
  int get hashCode {
    final hash = const DeepCollectionEquality().hash;
    return epubTextContentFileRef.hashCode ^
        title.hashCode ^
        anchor.hashCode ^
        hash(subChapters);
  }

  @override
  bool operator ==(covariant EpubChapterRef other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.epubTextContentFileRef == epubTextContentFileRef &&
        other.title == title &&
        other.anchor == anchor &&
        listEquals(other.subChapters, subChapters);
  }

  String get htmlContent => epubTextContentFileRef!.asText;

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters.length}';
  }

  EpubChapter get chapter => EpubChapter(
      title: title,
      anchor: anchor,
      htmlContent: htmlContent,
      subChapters: [...subChapters.chapters]);
}

extension ChaptersRefExt on Iterable<EpubChapterRef> {
  Iterable<EpubChapter> get chapters => map((cr) => cr.chapter);
}
