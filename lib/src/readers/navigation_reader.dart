import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:epub_plus/epub_plus.dart';
import 'package:epub_plus/src/readers/package_reader.dart';
import 'package:xml/xml.dart' as xml;

import '../schema/navigation/epub_navigation_list.dart';
import '../schema/navigation/epub_navigation_page_list.dart';
import '../utils/zip_path_utils.dart';
import 'root_file_path_reader.dart';

// ignore: omit_local_variable_types

extension NavigationReaderExt on Archive {
  Future<EpubNavigation> get epubNavigation async {
    final package = await epubPackage;
    final contentDirectoryPath = await epubContentDirectoryPath;
    switch (package.version) {
      case null:
        throw UnimplementedError('unimplemented epub version');
      case EpubVersion.epub2:
        return _navV2(
            package: package, contentDirectoryPath: contentDirectoryPath);
      case EpubVersion.epub3:
        return _navV3(
            package: package, contentDirectoryPath: contentDirectoryPath);
    }
  }

  EpubNavigation _navV2(
      {required EpubPackage package, required String contentDirectoryPath}) {
    var tocId = package.spine?.tableOfContents;
    if (tocId == null || tocId.isEmpty) {
      throw Exception('EPUB parsing error: TOC ID is empty.');
    }

    final tocManifestItem = package.manifest?.items.firstWhereOrNull(
      (item) => item.id?.toLowerCase() == tocId.toLowerCase(),
    );

    if (tocManifestItem == null) {
      throw Exception(
        'EPUB parsing error: TOC item $tocId not found in EPUB manifest.',
      );
    }

    final tocFileEntryPath =
        ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);
    final tocFileEntry = files.firstWhereOrNull(
      (file) => file.name.toLowerCase() == tocFileEntryPath?.toLowerCase(),
    );
    if (tocFileEntry == null) {
      throw Exception(
        'EPUB parsing error: TOC file $tocFileEntryPath not found in archive.',
      );
    }

    var containerDocument = xml.XmlDocument.parse(
      convert.utf8.decode(tocFileEntry.content),
    );

    const ncxNamespace = 'http://www.daisy.org/z3986/2005/ncx/';
    final ncxNode = containerDocument
        .findAllElements('ncx', namespace: ncxNamespace)
        .firstOrNull;

    if (ncxNode == null) {
      throw Exception(
          'EPUB parsing error: TOC file does not contain ncx element.');
    }

    final headNode =
        ncxNode.findAllElements('head', namespace: ncxNamespace).firstOrNull;

    if (headNode == null) {
      throw Exception(
        'EPUB parsing error: TOC file does not contain head element.',
      );
    }

    final navigationHead = EpubNavigationHead.fromXml(headNode);

    final docTitleNode =
        ncxNode.findElements('docTitle', namespace: ncxNamespace).firstOrNull;

    if (docTitleNode == null) {
      throw Exception(
        'EPUB parsing error: TOC file does not contain docTitle element.',
      );
    }

    final navigationDocTitle = EpubNavigationDocTitle.fromXml(docTitleNode);
    final docAuthors = ncxNode
        .findElements('docAuthor', namespace: ncxNamespace)
        .map<EpubNavigationDocAuthor>(
          (docAuthorNode) => EpubNavigationDocAuthor.fromXml(docAuthorNode),
        )
        .toList();

    final navMapNode =
        ncxNode.findElements('navMap', namespace: ncxNamespace).firstOrNull;
    if (navMapNode == null) {
      throw Exception(
        'EPUB parsing error: TOC file does not contain navMap element.',
      );
    }

    final navMap = EpubNavigationMap.fromXml(navMapNode);
    final pageListNode =
        ncxNode.findElements('pageList', namespace: ncxNamespace).firstOrNull;
    final pageList = switch (pageListNode) {
      xml.XmlElement element => EpubNavigationPageList.fromXml(element),
      null => null,
    };

    final navLists = ncxNode
        .findElements('navList', namespace: ncxNamespace)
        .map<EpubNavigationList>(
          (navigationListNode) =>
              EpubNavigationList.fromXml(navigationListNode),
        )
        .toList();

    return EpubNavigation(
      head: navigationHead,
      docTitle: navigationDocTitle,
      docAuthors: docAuthors,
      navMap: navMap,
      pageList: pageList,
      navLists: navLists,
    );
  }

  EpubNavigation _navV3(
      {required EpubPackage package, required String contentDirectoryPath}) {
    final tocManifestItem = package.manifest?.items.firstWhereOrNull(
      (element) => element.properties == 'nav',
    );
    if (tocManifestItem == null) {
      throw Exception(
        'EPUB parsing error: TOC item, not found in EPUB manifest.',
      );
    }

    String? tocFileEntryPath =
        ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);
    final tocFileEntry = files.firstWhereOrNull(
      (file) => file.name.toLowerCase() == tocFileEntryPath!.toLowerCase(),
    );
    if (tocFileEntry == null) {
      throw Exception(
        'EPUB parsing error: TOC file $tocFileEntryPath not found in archive.',
      );
    }
    //Get relative toc file path
    tocFileEntryPath =
        '${((tocFileEntryPath!.split('/')..removeLast())..removeAt(0)).join('/')}/';

    var containerDocument =
        xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

    final headNode = containerDocument.findAllElements('head').firstOrNull;
    if (headNode == null) {
      throw Exception(
        'EPUB parsing error: TOC file does not contain head element.',
      );
    }

    final titles = package.metadata!.titles;
    final docTitle = EpubNavigationDocTitle(titles: titles);

    final navNode = containerDocument.findAllElements('nav').firstOrNull;
    if (navNode == null) {
      throw Exception(
        'EPUB parsing error: TOC file does not contain head element.',
      );
    }
    final navMapNode = navNode.findElements('ol').single;

    final navMap = EpubNavigationMap.fromXmlV3(tocFileEntryPath, navMapNode);

    //TODO : Implement pagesLists
//      xml.XmlElement pageListNode = ncxNode
//          .findElements("pageList", namespace: ncxNamespace)
//          .firstWhere((xml.XmlElement elem) => elem != null,
//          orElse: () => null);
//      if (pageListNode != null) {
//        EpubNavigationPageList pageList = readNavigationPageList(pageListNode);
//        result.PageList = pageList;
//      }
    return EpubNavigation(
      docTitle: docTitle,
      navMap: navMap,
    );
  }
}
