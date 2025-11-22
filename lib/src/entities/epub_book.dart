import 'package:collection/collection.dart';
import 'package:epub_plus/epub_plus.dart';

class EpubBook {
  final String? title;
  final String? author;
  final List<String?> authors;
  final EpubSchema? schema;
  final EpubContent? content;
  final EpubByteContentItem? cover;
  final List<EpubChapter> chapters;
  final EpubStateResult state;
  const EpubBook(
      {this.title,
      this.author,
      this.authors = const <String>[],
      this.schema,
      this.content,
      this.cover,
      this.chapters = const <EpubChapter>[],
      this.state = const EpubStateResult()});

  @override
  int get hashCode {
    final hash = const DeepCollectionEquality().hash;
    return title.hashCode ^
        author.hashCode ^
        hash(authors) ^
        schema.hashCode ^
        content.hashCode ^
        cover.hashCode ^
        hash(chapters);
  }

  @override
  bool operator ==(covariant EpubBook other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.title == title &&
        other.author == author &&
        listEquals(other.authors, authors) &&
        other.schema == schema &&
        other.content == content &&
        other.cover == cover &&
        listEquals(other.chapters, chapters);
  }

  EpubBook copyWith({
    String? title,
    String? author,
    List<String?>? authors,
    EpubSchema? schema,
    EpubContent? content,
    EpubByteContentItem? cover,
    List<EpubChapter>? chapters,
  }) {
    return EpubBook(
      title: title ?? this.title,
      author: author ?? this.author,
      authors: authors ?? this.authors,
      schema: schema ?? this.schema,
      content: content ?? this.content,
      cover: cover ?? this.cover,
      chapters: chapters ?? this.chapters,
    );
  }
}
