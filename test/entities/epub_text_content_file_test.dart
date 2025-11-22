library;

import 'package:epub_plus/epub_plus.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var reference = EpubTextContentItem(
    content: "Hello",
    mimeType: "application/test",
    contentType: EpubContentType.other,
    filename: "orthrosFile",
  );

  late EpubTextContentItem testFile;

  setUp(() async {
    testFile = reference.copyWith();
  });

  group("EpubTextContentFile", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFile, equals(reference));
      });

      test("is false when Content changes", () async {
        testFile = testFile.copyWith(content: "Goodbye");
        expect(testFile, isNot(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFile = testFile.copyWith(mimeType: "application/different");
        expect(testFile, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFile = testFile.copyWith(contentType: EpubContentType.css);
        expect(testFile, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFile = testFile.copyWith(filename: "a_different_file_name");
        expect(testFile, isNot(reference));
      });
    });
    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFile.hashCode, equals(reference.hashCode));
      });

      test('changes when Content changes', () async {
        testFile = testFile.copyWith(content: "Goodbye");
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFile = testFile.copyWith(mimeType: "application/different");
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFile = testFile.copyWith(contentType: EpubContentType.css);
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile = testFile.copyWith(filename: "a_different_file_name");
        expect(testFile.hashCode, isNot(reference.hashCode));
      });
    });
  });
}

extension on EpubTextContentItem {
  EpubTextContentItem copyWith({
    String? content,
    String? mimeType,
    EpubContentType? contentType,
    String? filename,
  }) {
    return EpubTextContentItem(
      content: content ?? this.content,
      mimeType: mimeType ?? this.mimeType,
      contentType: contentType ?? this.contentType,
      filename: filename ?? this.filename,
    );
  }
}
