import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

extension SchemaReaderExt on Archive {
  Future<EpubSchema> get epubSchema async {
    final package = await epubPackage;
    final navigation = await epubNavigation;
    final contentDirectoryPath = await epubContentDirectoryPath;
    return EpubSchema(
      package: package,
      navigation: navigation,
      contentDirectoryPath: contentDirectoryPath,
    );
  }
}
