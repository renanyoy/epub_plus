import '../entities/content/epub_content_type.dart';
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/content/epub_byte_content_item_ref.dart';
import '../ref_entities/content/epub_content_item_ref.dart';
import '../ref_entities/epub_content_ref.dart';
import '../ref_entities/content/epub_text_content_item_ref.dart';
import '../utils/uri_decode.dart';

extension ContentReaderExt on EpubBookRef {
  EpubContentRef get content {
    final html = <String, EpubTextContentItemRef>{};
    final css = <String, EpubTextContentItemRef>{};
    final images = <String, EpubByteContentFileRef>{};
    final fonts = <String, EpubByteContentFileRef>{};
    final allFiles = <String, EpubContentItemRef>{};

    for (final manifestItem in schema!.package!.manifest!.items) {
      var fileName = manifestItem.href ?? '';
      var contentMimeType = manifestItem.mediaType!;
      var contentType = EpubContentType.fromMimeType(contentMimeType);
      switch (contentType) {
        case EpubContentType.xhtml11:
        case EpubContentType.css:
        case EpubContentType.oeb1Document:
        case EpubContentType.oeb1CSS:
        case EpubContentType.xml:
        case EpubContentType.dtbook:
        case EpubContentType.dtbookNCX:
          var epubTextContentFile = EpubTextContentItemRef(
            bookRef: this,
            fileName: decodeUri(fileName),
            contentMimeType: contentMimeType,
          );

          switch (contentType) {
            case EpubContentType.xhtml11:
              html[fileName] = epubTextContentFile;
            case EpubContentType.css:
              css[fileName] = epubTextContentFile;
            default:
              break;
          }
          allFiles[fileName] = epubTextContentFile;
        default:
          var epubByteContentFile = EpubByteContentFileRef(
            bookRef: this,
            fileName: decodeUri(fileName),
            contentMimeType: contentMimeType,
            contentType: contentType,
          );

          switch (contentType) {
            case EpubContentType.imageGIF:
            case EpubContentType.imageJPEG:
            case EpubContentType.imagePNG:
            case EpubContentType.imageSVG:
            case EpubContentType.imageBMP:
              images[fileName] = epubByteContentFile;
            case EpubContentType.fontTrueType:
            case EpubContentType.fontOpenType:
              fonts[fileName] = epubByteContentFile;
            default:
              break;
          }
          allFiles[fileName] = epubByteContentFile;
      }
    }
    return EpubContentRef(
      html: html,
      css: css,
      images: images,
      fonts: fonts,
      allFiles: allFiles,
    );
  }
}
