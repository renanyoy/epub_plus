library;

import 'package:archive/archive.dart';
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/ref_entities/content/epub_byte_content_item_ref.dart';
import 'package:test/test.dart';

Future<void> main() async {
  Archive arch = Archive();
  EpubBookRef ref = EpubBookRef(archive: arch);

  var reference = EpubByteContentFileRef(
    bookRef: ref,
    contentMimeType: "application/test",
    contentType: EpubContentType.other,
    fileName: "orthrosFile",
  );

  late EpubByteContentFileRef testFileRef;

  setUp(() async {
    Archive arch2 = Archive();
    EpubBookRef ref2 = EpubBookRef(archive: arch2);

    testFileRef = reference.copyWith(bookRef: ref2);
  });

  group("EpubByteContentFileRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFileRef, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFileRef =
            testFileRef.copyWith(contentMimeType: "application/different");
        expect(testFileRef, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFileRef = testFileRef.copyWith(contentType: EpubContentType.css);
        expect(testFileRef, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFileRef = testFileRef.copyWith(fileName: "a_different_file_name");
        expect(testFileRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFileRef.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFileRef =
            testFileRef.copyWith(contentMimeType: "application/different");
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFileRef = testFileRef.copyWith(contentType: EpubContentType.css);
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFileRef = testFileRef.copyWith(fileName: "a_different_file_name");
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}

extension on EpubByteContentFileRef {
  EpubByteContentFileRef copyWith({
    EpubBookRef? bookRef,
    String? contentMimeType,
    EpubContentType? contentType,
    String? fileName,
  }) {
    return EpubByteContentFileRef(
      bookRef: bookRef ?? this.bookRef,
      contentMimeType: contentMimeType ?? this.contentMimeType,
      contentType: contentType ?? this.contentType,
      fileName: fileName ?? this.fileName,
    );
  }
}
