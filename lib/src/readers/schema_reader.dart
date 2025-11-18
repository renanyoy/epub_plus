import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import '../utils/zip_path_utils.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

extension SchemaReaderExt on Archive {
  Future<EpubSchema> get epubSchema async {
    final rootFilePath = (await epubRootFilePath)!;
    final contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);

    final package = await epubPackage;

    final navigation = await NavigationReader.readNavigation(
      this,
      contentDirectoryPath,
      package,
    );

    return EpubSchema(
      package: package,
      navigation: navigation,
      contentDirectoryPath: contentDirectoryPath,
    );
  }
}
