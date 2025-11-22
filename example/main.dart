// ignore_for_file: unused_local_variable

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:epub_plus/epub_plus.dart';
import 'package:collection/collection.dart';

void main(List<String> args) async {
  //Get the epub into memory somehow
  String fileName = "alicesAdventuresUnderGround.epub";
  String fullPath = path.join(
    io.Directory.current.path,
    'assets',
    fileName,
  );
  var targetFile = io.File(fullPath);
  final bytes = await targetFile.readAsBytes();

  // Opens a book and reads all of its content into the memory
  EpubBook epubBook = (await EpubReader.readBook(bytes));

  // COMMON PROPERTIES

  // Book's title
  String? title = epubBook.title;

  // Book's authors (comma separated list)
  String? author = epubBook.author;

  // Book's authors (list of authors names)
  List<String?>? authors = epubBook.authors;

  // Book's cover image (null if there is no cover)
  Image? coverImage = epubBook.cover?.asImage;

  // CHAPTERS

  // Enumerating chapters
  for (var chapter in epubBook.chapters) {
    // Title of chapter
    String? chapterTitle = chapter.title;

    // HTML content of current chapter
    String? chapterHtmlContent = chapter.htmlContent;

    // Nested chapters
    List<EpubChapter> subChapters = chapter.subChapters;
  }

  // CONTENT

  // Book's content (HTML files, stlylesheets, images, fonts, etc.)
  EpubContent? bookContent = epubBook.content;

  // IMAGES

  // All images in the book (file name is the key)
  Map<String, EpubByteContentItem>? images = bookContent?.images;

  EpubByteContentItem? firstImage =
      images?.values.firstOrNull; // Get the first image in the book

  // Content type (e.g. EpubContentType.IMAGE_JPEG, EpubContentType.IMAGE_PNG)
  EpubContentType contentType = firstImage!.contentType;

  // MIME type (e.g. "image/jpeg", "image/png")
  String mimeContentType = firstImage.mimeType;

  // HTML & CSS

  // All XHTML files in the book (file name is the key)
  Map<String, EpubTextContentItem>? htmlFiles = bookContent?.html;

  // All CSS files in the book (file name is the key)
  Map<String, EpubTextContentItem>? cssFiles = bookContent?.css;

  // Entire HTML content of the book
  htmlFiles?.values.forEach((EpubTextContentItem htmlFile) {
    String? htmlContent = htmlFile.content;
  });

  // All CSS content in the book
  cssFiles?.values.forEach((EpubTextContentItem cssFile) {
    String cssContent = cssFile.content;
  });

  // OTHER CONTENT

  // All fonts in the book (file name is the key)
  Map<String, EpubByteContentItem>? fonts = bookContent?.fonts;

  // All files in the book (including HTML, CSS, images, fonts, and other types of files)
  Map<String, EpubContentItem>? allFiles = bookContent?.allFiles;

  // ACCESSING RAW SCHEMA INFORMATION

  // EPUB OPF data
  EpubPackage? package = epubBook.schema?.package;

  // Enumerating book's contributors
  package?.metadata?.contributors.forEach((contributor) {
    String contributorName = contributor.contributor!;
    String contributorRole = contributor.role!;
  });

  // EPUB NCX data
  EpubNavigation navigation = epubBook.schema!.navigation!;

  // Enumerating NCX metadata
  navigation.head?.metadata.forEach((meta) {
    String metadataItemName = meta.name!;
    String metadataItemContent = meta.content!;
  });

  // Write the Book
  var written = EpubWriter.writeBook(epubBook);

  if (written != null) {
    // Read the book into a new object!
    var newBook = await EpubReader.readBook(Uint8List.fromList(written));
  }
}
