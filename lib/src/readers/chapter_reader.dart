import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/readers/content_reader.dart';
import '../ref_entities/epub_text_content_file_ref.dart';

extension ChapterReaderExt on EpubBookRef {
  EpubReturnValue<List<EpubChapterRef>> get chapters {
    if (schema?.navigation?.navMap?.points.isNotEmpty ?? false) {
      return _chapters(schema!.navigation!.navMap!.points);
    }
    if (schema?.package?.spine?.items.isNotEmpty ?? false) {
      return _spineChapters();
    }
    return EpubReturnValue(
        value: <EpubChapterRef>[],
        state: {EpubState.missingChapters},
        errors: [EpubError(message: 'no navigation schema')]);
  }

  EpubReturnValue<List<EpubChapterRef>> _spineChapters() {
    final result = <EpubChapterRef>[];
    final manifest = schema!.package!.manifest!;
    for (final s in schema!.package!.spine!.items) {
      final i = manifest.find(id: s.idRef);
      if (i == null) {
        continue;
      }
      final type = EpubContentType.fromMimeType(i.mediaType!);
      if (type != EpubContentType.xhtml11) continue;
      final chapterRef = EpubChapterRef(
          epubTextContentFileRef: EpubTextContentFileRef(
              epubBookRef: this,
              fileName: i.href,
              contentType: type,
              contentMimeType: i.mediaType),
          contentFileName: i.href);
      result.add(chapterRef);
    }
    return EpubReturnValue(value: result, state: {
      EpubState.spineChapters
    }, errors: [
      EpubError(message: 'no navigation chapters, using spine as chapters')
    ]);
  }

  EpubReturnValue<List<EpubChapterRef>> _chapters(
      List<EpubNavigationPoint> navigationPoints) {
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
      if (!content.html.containsKey(contentFileName)) {
        // TODO: try to find file in archive
        ret.add(
            state: {EpubState.missingChapters},
            error: EpubError(
              message:
                  'Incorrect EPUB manifest: item with href = "$contentFileName" is missing.',
            ));
        continue;
      }
      htmlContentFileRef = content.html[contentFileName];
      final chapterRef = EpubChapterRef(
        epubTextContentFileRef: htmlContentFileRef,
        title: navigationPoint.navigationLabels.first.text,
        contentFileName: contentFileName,
        anchor: anchor,
        subChapters:
            ret.combine(_chapters(navigationPoint.childNavigationPoints))!,
      );
      result.add(chapterRef);
    }
    return ret.returns(result);
  }
}
