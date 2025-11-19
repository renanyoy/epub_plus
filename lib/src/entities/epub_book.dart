import 'package:collection/collection.dart';
import 'package:epub_plus/epub_plus.dart';

class EpubBook {
  final String? title;
  final String? author;
  final List<String?> authors;
  final EpubSchema? schema;
  final EpubContent? content;
  final EpubByteContentFile? coverFile;
  final List<EpubChapter> chapters;

  const EpubBook({
    this.title,
    this.author,
    this.authors = const <String>[],
    this.schema,
    this.content,
    this.coverFile,
    this.chapters = const <EpubChapter>[],
  });

  @override
  int get hashCode {
    final hash = const DeepCollectionEquality().hash;
    return title.hashCode ^
        author.hashCode ^
        hash(authors) ^
        schema.hashCode ^
        content.hashCode ^
        coverFile.hashCode ^
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
        other.coverFile == coverFile &&
        listEquals(other.chapters, chapters);
  }
}
