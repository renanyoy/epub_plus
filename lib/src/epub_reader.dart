import 'dart:async';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/readers/chapter_reader.dart';

import 'readers/book_cover_reader.dart';
import 'readers/content_reader.dart';
import 'readers/schema_reader.dart';

/// A class that provides the primary interface to read Epub files.
///
/// To open an Epub and load all data at once use the [readBook()] method.
///
/// To open an Epub and load only basic metadata use the [openBook()] method.
/// This is a good option to quickly load text-based metadata, while leaving the
/// heavier lifting of loading images and main content for subsequent operations.
///
/// ## Example
/// ```dart
/// // Read the basic metadata.
/// EpubBookRef epub = await EpubReader.openBook(epubFileBytes);
/// // Extract values of interest.
/// String title = epub.Title;
/// String author = epub.Author;
/// var metadata = epub.Schema.Package.Metadata;
/// String genres = metadata.Subjects.join(', ');
/// ```
class EpubReader {
  /// Loads basics metadata.
  ///
  /// Opens the book asynchronously without reading its main content.
  /// Holds the handle to the EPUB file.
  ///
  /// Argument [bytes] should be the bytes of
  /// the epub file you have loaded with something like the [dart:io] package's
  /// [readAsBytes()].
  ///
  /// This is a fast and convenient way to get the most important information
  /// about the book, notably the [Title], [Author] and [AuthorList].
  /// Additional information is loaded in the [Schema] property such as the
  /// Epub version, Publishers, Languages and more.
  static Future<EpubBookRef> openBook(FutureOr<Uint8List> bytes) async {
    Uint8List loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }
    final epubArchive = ZipDecoder().decodeBytes(loadedBytes);
    final schema = await epubArchive.epubSchema;
    final title = schema.package!.metadata!.titles
        .firstWhere((String name) => true, orElse: () => '');
    final authors = schema.package!.metadata!.creators
        .map((EpubMetadataCreator creator) => creator.creator)
        .whereType<String>()
        .toList();
    final author = authors.join(', ');
    return EpubBookRef(
      epubArchive: epubArchive,
      title: title,
      author: author,
      authors: authors,
      schema: schema,
    );
  }

  /// Opens the book asynchronously and reads all of its content into the memory. Does not hold the handle to the EPUB file.
  static Future<EpubBook> readBook(FutureOr<Uint8List> bytes) async {
    final ret = EpubStateCollection();
    final epubBookRef = await openBook(await bytes);
    final schema = epubBookRef.schema;
    final title = epubBookRef.title;
    final authors = epubBookRef.authors;
    final author = epubBookRef.author;
    final content = epubBookRef.content.content;
    EpubByteContentFile? coverFile;
    try {
      coverFile = epubBookRef.coverContent?.byteContentFile;
    } catch (error, stackTrace) {
      ret.add(
          state: {EpubState.missingCover},
          error:
              EpubError(message: error.toString(), exceptionTrace: stackTrace));
    }
    final chapterRefs = ret.combine(epubBookRef.chapters)!;
    final chapters = [...chapterRefs.chapters];
    return EpubBook(
        title: title,
        author: author,
        authors: authors,
        schema: schema,
        content: content,
        coverFile: coverFile,
        chapters: chapters,
        state: ret.result);
  }
}
