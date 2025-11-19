import 'package:epub_plus/src/ref_entities/epub_text_content_file_ref.dart';

class EpubSpineItemRef {
  final EpubTextContentFileRef? epubTextContentFileRef;
  final String? idRef;
  final bool isLinear;

  const EpubSpineItemRef({
    this.epubTextContentFileRef,
    this.idRef,
    required this.isLinear,
  });

  @override
  int get hashCode => idRef.hashCode ^ isLinear.hashCode;

  @override
  bool operator ==(covariant EpubSpineItemRef other) {
    if (identical(this, other)) return true;

    return other.idRef == idRef && other.isLinear == isLinear;
  }

  String readHtmlContent() => epubTextContentFileRef!.asText;

  @override
  String toString() {
    return 'IdRef: $idRef';
  }
}
