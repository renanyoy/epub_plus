library;

import 'package:epub_plus/epub_plus.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var reference = EpubBook(
    author: "orthros",
    authors: ["orthros"],
    chapters: [EpubChapter()],
    content: EpubContent(),
    schema: EpubSchema(),
    title: "A Dissertation on Epubs",
  );

  late EpubBook testBook;
  setUp(() async {
    testBook = reference.copyWith();
  });

  group("EpubBook", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBook, equals(reference));
      });

      test("is false when Content changes", () async {
        var file = EpubTextContentItem(
          content: "Hello",
          contentMimeType: "application/txt",
          contentType: EpubContentType.other,
          fileName: "orthros.txt",
        );

        EpubContent content = EpubContent(
          allFiles: {"hello": file},
        );
        testBook = testBook.copyWith(content: content);

        expect(testBook, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBook = testBook.copyWith(author: "NotOrthros");
        expect(testBook, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBook = testBook.copyWith(authors: ["NotOrthros"]);
        expect(testBook, isNot(reference));
      });

      test("is false when Chapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
        );
        testBook = testBook.copyWith(chapters: [chapter]);
        expect(testBook, isNot(reference));
      });

      test("is false when Schema changes", () async {
        var schema = EpubSchema(
          contentDirectoryPath: "some/random/path",
        );
        testBook = testBook.copyWith(schema: schema);
        expect(testBook, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBook = testBook.copyWith(title: "The Philosophy of Epubs");
        expect(testBook, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBook.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        var file = EpubTextContentItem(
          content: "Hello",
          contentMimeType: "application/txt",
          contentType: EpubContentType.other,
          fileName: "orthros.txt",
        );

        EpubContent content = EpubContent(
          allFiles: {"hello": file},
        );
        testBook = testBook.copyWith(content: content);

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Author changes", () async {
        testBook = testBook.copyWith(author: "NotOrthros");
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBook = testBook.copyWith(authors: ["NotOrthros"]);
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Chapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
        );
        testBook = testBook.copyWith(chapters: [chapter]);
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Schema changes", () async {
        var schema = EpubSchema(
          contentDirectoryPath: "some/random/path",
        );
        testBook = testBook.copyWith(schema: schema);
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBook = testBook.copyWith(title: "The Philosophy of Epubs");
        expect(testBook.hashCode, isNot(reference.hashCode));
      });
    });
  });
}

