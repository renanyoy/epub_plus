import 'package:image/image.dart';

import '../entities/epub_byte_content_file.dart';
import 'epub_content_file_ref.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  EpubByteContentFileRef({
    required super.epubBookRef,
    super.fileName,
    super.contentMimeType,
    super.contentType,
  });

  Image? get asImage => decodeImage(content);

  EpubByteContentFile get contentFile {
    final result = EpubByteContentFile(
      fileName: fileName,
      contentType: contentType,
      contentMimeType: contentMimeType,
      content: content,
    );
    return result;
  }
}
