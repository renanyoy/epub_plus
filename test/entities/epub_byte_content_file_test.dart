library;

import 'dart:typed_data';

import 'package:epub_plus/epub_plus.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var reference = EpubByteContentItem(
    content: Uint8List.fromList([0, 1, 2, 3]),
    mimeType: "application/test",
    contentType: EpubContentType.other,
    filename: "orthrosFile",
  );

  late EpubByteContentItem testFile;

  setUp(() async {
    testFile = reference.copyWith();
  });

  group("EpubByteContentFile", () {
    test(".equals is true for equivalent objects", () async {
      expect(testFile, equals(reference));
    });

    test(".equals is false when Content changes", () async {
      testFile = testFile.copyWith(content: Uint8List.fromList([3, 2, 1, 0]));
      expect(testFile, isNot(reference));
    });

    test(".equals is false when ContentMimeType changes", () async {
      testFile = testFile.copyWith(mimeType: "application/different");
      expect(testFile, isNot(reference));
    });

    test(".equals is false when ContentType changes", () async {
      testFile = testFile.copyWith(contentType: EpubContentType.css);
      expect(testFile, isNot(reference));
    });

    test(".equals is false when FileName changes", () async {
      testFile = testFile.copyWith(filename: "a_different_file_name");
      expect(testFile, isNot(reference));
    });

    test(".hashCode is the same for equivalent content", () async {
      expect(testFile.hashCode, equals(reference.hashCode));
    });

    test('.hashCode changes when Content changes', () async {
      testFile = testFile.copyWith(content:Uint8List.fromList([3, 2, 1, 0]));
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when ContentMimeType changes', () async {
      testFile = testFile.copyWith(mimeType: "application/different");
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when ContentType changes', () async {
      testFile = testFile.copyWith(contentType: EpubContentType.css);
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when FileName changes', () async {
      testFile = testFile.copyWith(filename: "a_different_file_name");
      expect(testFile.hashCode, isNot(reference.hashCode));
    });
  });
}

extension on EpubByteContentItem {
  EpubByteContentItem copyWith({
    Uint8List? content,
    String? mimeType,
    EpubContentType? contentType,
    String? filename,
  }) {
    return EpubByteContentItem(
      content: content ?? this.content,
      mimeType: mimeType ?? this.mimeType,
      contentType: contentType ?? this.contentType,
      filename: filename ?? this.filename,
    );
  }
}
