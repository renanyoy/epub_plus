import 'package:image/image.dart';

import 'epub__content_item_ref.dart';

class EpubByteContentFileRef extends EpubContentItemRef {
  EpubByteContentFileRef({
    required super.bookRef,
    super.fileName,
    super.contentMimeType,
    super.contentType,
  });

  Image? get asImage => decodeImage(content);
}
