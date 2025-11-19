import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/readers/root_file_path_reader.dart';
import 'package:xml/xml.dart';

extension PackageReaderExt on Archive {
  Future<EpubPackage> get epubPackage async {
    final epubRootFilePath = await this.epubRootFilePath;
    var rootFileEntry = files.firstWhereOrNull(
        (ArchiveFile testFile) => testFile.name == epubRootFilePath);
    if (rootFileEntry == null) {
      throw Exception('EPUB parsing error: root file not found in archive.');
    }
    var containerDocument =
        XmlDocument.parse(convert.utf8.decode(rootFileEntry.content));
    var opfNamespace = 'http://www.idpf.org/2007/opf';
    var packageNode = containerDocument
        .findElements('package', namespace: opfNamespace)
        .firstWhere((XmlElement? elem) => elem != null);
    EpubVersion? version;
    final epubVersionValue = packageNode.getAttribute('version');
    if (epubVersionValue == '2.0') {
      version = EpubVersion.epub2;
    } else if (epubVersionValue == '3.0') {
      version = EpubVersion.epub3;
    } else {
      throw Exception('Unsupported EPUB version: $epubVersionValue.');
    }
    var metadataNode = packageNode
        .findElements('metadata', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }
    final metadata = EpubMetadata.fromXml(metadataNode, version);

    var manifestNode = packageNode
        .findElements('manifest', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }
    final manifest = EpubManifest.fromXml(manifestNode);

    var spineNode = packageNode
        .findElements('spine', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }
        

    final spine = EpubSpine.fromXml(spineNode);

    final guideNode = packageNode
        .findElements('guide', namespace: opfNamespace)
        .firstWhereOrNull((XmlElement? elem) => elem != null);
    EpubGuide? guide;
    if (guideNode != null) {
      guide = EpubGuide.fromXml(guideNode);
    }

    return EpubPackage(
      version: version,
      metadata: metadata,
      manifest: manifest,
      spine: spine,
      guide: guide,
    );
  }
}
