import 'package:archive/archive.dart';
import 'package:collection/collection.dart';

import '../entities/epub_schema.dart';

class EpubBookRef {
  final Archive archive;
  final String? title;
  final String? author;
  final List<String> authors;
  final EpubSchema? schema;

  const EpubBookRef({
    required this.archive,
    this.title,
    this.author,
    this.authors = const [],
    this.schema,
  });

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        authors.hashCode ^
        schema.hashCode;
  }

  @override
  bool operator ==(covariant EpubBookRef other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.title == title &&
        other.author == author &&
        listEquals(other.authors, authors) &&
        other.schema == schema;
  }

  EpubBookRef copyWith({
    Archive? archive,
    String? title,
    List<String>? authors,
    String? author,
    EpubSchema? schema,
  }) {
    return EpubBookRef(
        archive: archive ?? this.archive,
        title: title ?? this.title,
        authors: authors ?? this.authors,
        author: author ?? this.author,
        schema: schema ?? this.schema);
  }
}
