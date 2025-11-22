library;

import 'package:archive/archive.dart';
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/ref_entities/content/epub_text_content_item_ref.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var arch = Archive();
  var epubRef = EpubBookRef(archive: arch);

  var reference = EpubTextContentItemRef(
    bookRef: epubRef,
    mimeType: "application/test",
    filename: "orthrosFile",
  );

  late EpubTextContentItemRef testFile;

  setUp(() async {
    var arch2 = Archive();
    var epubRef2 = EpubBookRef(archive: arch2);

    testFile = reference.copyWith(bookRef: epubRef2);
  });

  group("EpubTextContentFile", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFile, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFile = testFile.copyWith(mimeType: "application/different");
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

      test('changes when ContentMimeType changes', () async {
        testFile = testFile.copyWith(mimeType: "application/different");
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile = testFile.copyWith(filename: "a_different_file_name");
        expect(testFile.hashCode, isNot(reference.hashCode));
      });
    });
  });
}

