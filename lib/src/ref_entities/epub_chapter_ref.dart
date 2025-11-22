import 'package:collection/collection.dart';

import '../entities/epub_chapter.dart';
import 'content/epub_text_content_item_ref.dart';

class EpubChapterRef {
  final EpubTextContentItemRef? epubTextContentFileRef;
  final String? title;
  final String? anchor;
  final List<EpubChapterRef> subChapters;

  const EpubChapterRef({
    this.epubTextContentFileRef,
    this.title,
    this.anchor,
    this.subChapters = const <EpubChapterRef>[],
  });

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
        other.htmlContent == htmlContent &&
        listEquals(other.subChapters, subChapters);
  }

  EpubChapterRef copyWith({
    EpubTextContentItemRef? epubTextContentFileRef,
    String? anchor,
    List<EpubChapterRef>? subChapters,
    String? title,
  }) {
    return EpubChapterRef(
      epubTextContentFileRef:
          epubTextContentFileRef ?? this.epubTextContentFileRef,
      anchor: anchor ?? this.anchor,
      subChapters: subChapters ?? this.subChapters,
      title: title ?? this.title,
    );
  }
}

extension ChaptersRefExt on Iterable<EpubChapterRef> {
  Iterable<EpubChapter> get chapters => map((cr) => cr.chapter);
}
