import 'package:image/image.dart';

import '../epub_book_ref.dart';
import 'epub__content_item_ref.dart';

class EpubByteContentFileRef extends EpubContentItemRef {
  EpubByteContentFileRef({
    required super.bookRef,
    required super.filename,
    required super.mimeType,
  });

  Image? get asImage => decodeImage(content);

  EpubByteContentFileRef copyWith({
    EpubBookRef? bookRef,
    String? mimeType,
    String? filename,
  }) {
    return EpubByteContentFileRef(
      bookRef: bookRef ?? this.bookRef,
      mimeType: mimeType ?? this.mimeType,
      filename: filename ?? this.filename,
    );
  }
}
