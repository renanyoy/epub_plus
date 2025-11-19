import 'package:image/image.dart';

import 'epub_content_file_ref.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  EpubByteContentFileRef({
    required super.epubBookRef,
    super.fileName,
    super.contentMimeType,
    super.contentType,
  });

  Image? get asImage => decodeImage(content);
}
