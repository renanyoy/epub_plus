import 'package:epub_plus/src/readers/content_reader.dart';
import 'package:epub_plus/src/epub_state.dart';

import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/navigation/epub_navigation_point.dart';

extension ChapterReaderExt on EpubBookRef {
  EpubReturnValue<List<EpubChapterRef>> get chapters {
    if (schema!.navigation == null) {
      return EpubReturnValue(
          value: <EpubChapterRef>[],
          state: {EpubState.missingChapters},
          errors: [EpubError(message: 'no navigation schema')]);
    }
    return getChaptersImpl(this, schema!.navigation!.navMap!.points);
  }

  static EpubReturnValue<List<EpubChapterRef>> getChaptersImpl(
      EpubBookRef bookRef, List<EpubNavigationPoint> navigationPoints) {
    final ret = EpubStateCollection();
    final result = <EpubChapterRef>[];
    for (final navigationPoint in navigationPoints) {
      String? contentFileName;
      String? anchor;
      if (navigationPoint.content?.source == null) continue;
      final contentSourceAnchorCharIndex =
          navigationPoint.content!.source!.indexOf('#');
      if (contentSourceAnchorCharIndex == -1) {
        contentFileName = navigationPoint.content!.source;
        anchor = null;
      } else {
        contentFileName = navigationPoint.content!.source!
            .substring(0, contentSourceAnchorCharIndex);
        anchor = navigationPoint.content!.source!
            .substring(contentSourceAnchorCharIndex + 1);
      }
      contentFileName = Uri.decodeFull(contentFileName!);
      EpubTextContentFileRef? htmlContentFileRef;
      if (!bookRef.content.html.containsKey(contentFileName)) {
        // TODO: try to find file in archive
        ret.add(
            state: {EpubState.missingChapters},
            error: EpubError(
              message:
                  'Incorrect EPUB manifest: item with href = "$contentFileName" is missing.',
            ));
        continue;
      }
      htmlContentFileRef = bookRef.content.html[contentFileName];
      final chapterRef = EpubChapterRef(
        epubTextContentFileRef: htmlContentFileRef,
        title: navigationPoint.navigationLabels.first.text,
        contentFileName: contentFileName,
        anchor: anchor,
        subChapters: ret.combine(
            getChaptersImpl(bookRef, navigationPoint.childNavigationPoints))!,
      );
      result.add(chapterRef);
    }
    return ret.returns(result);
  }
}
