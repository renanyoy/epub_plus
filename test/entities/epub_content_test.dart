library;

import 'dart:typed_data';

import 'package:epub_plus/epub_plus.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var reference = EpubContent();

  late EpubContent testContent;
  late EpubTextContentItem textContentFile;
  late EpubByteContentItem byteContentFile;

  setUp(() async {
    testContent = EpubContent();

    textContentFile = EpubTextContentItem(
      content: "Some string",
      contentMimeType: "application/text",
      contentType: EpubContentType.other,
      fileName: "orthros.txt",
    );

    byteContentFile = EpubByteContentItem(
      content: Uint8List.fromList([0, 1, 2, 3]),
      contentMimeType: "application/orthros",
      contentType: EpubContentType.other,
      fileName: "orthros.bin",
    );
  });

  group("EpubContent", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testContent, equals(reference));
      });

      test("is false when Html changes", () async {
        testContent = testContent.copyWith(html: {"someKey": textContentFile});
        expect(testContent, isNot(reference));
      });

      test("is false when Css changes", () async {
        testContent = testContent.copyWith(css: {"someKey": textContentFile});
        expect(testContent, isNot(reference));
      });

      test("is false when Images changes", () async {
        testContent =
            testContent.copyWith(images: {"someKey": byteContentFile});
        expect(testContent, isNot(reference));
      });

      test("is false when Fonts changes", () async {
        testContent = testContent.copyWith(fonts: {"someKey": byteContentFile});
        expect(testContent, isNot(reference));
      });

      test("is false when AllFiles changes", () async {
        testContent =
            testContent.copyWith(allFiles: {"someKey": byteContentFile});
        expect(testContent, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testContent.hashCode, equals(reference.hashCode));
      });

      test("is false when Html changes", () async {
        testContent = testContent.copyWith(html: {"someKey": textContentFile});
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Css changes", () async {
        testContent = testContent.copyWith(css: {"someKey": textContentFile});
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Images changes", () async {
        testContent =
            testContent.copyWith(images: {"someKey": byteContentFile});
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Fonts changes", () async {
        testContent = testContent.copyWith(fonts: {"someKey": byteContentFile});
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when AllFiles changes", () async {
        testContent =
            testContent.copyWith(allFiles: {"someKey": byteContentFile});
        expect(testContent.hashCode, isNot(reference.hashCode));
      });
    });
  });
}

extension on EpubContent {
  EpubContent copyWith({
    Map<String, EpubTextContentItem>? html,
    Map<String, EpubTextContentItem>? css,
    Map<String, EpubByteContentItem>? images,
    Map<String, EpubByteContentItem>? fonts,
    Map<String, EpubContentItem>? allFiles,
  }) {
    return EpubContent(
      html: html ?? this.html,
      css: css ?? this.css,
      images: images ?? this.images,
      fonts: fonts ?? this.fonts,
      allFiles: allFiles ?? this.allFiles,
    );
  }
}
