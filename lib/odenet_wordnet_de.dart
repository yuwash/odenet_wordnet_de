import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:xml/xml.dart';

// See https://globalwordnet.github.io/schemas/

const String deWordNetUrl =
    'https://github.com/hdaSprachtechnologie/odenet/raw/refs/heads/master/odenet/wordnet/deWordNet.xml';

enum PartOfSpeech { n, v, a, r, s, c, p, x, u }

const Map<PartOfSpeech, String> partOfSpeechLabels = {
  PartOfSpeech.n: 'Noun',
  PartOfSpeech.v: 'Verb',
  PartOfSpeech.a: 'Adjective',
  PartOfSpeech.r: 'Adverb',
  PartOfSpeech.s: 'Adjective Satellite',
  PartOfSpeech.c: 'Conjunction',
  PartOfSpeech.p: 'Adposition',
  PartOfSpeech.x: 'Other',
  PartOfSpeech.u: 'Unknown',
};

class LexicalResource {
  final XmlDocument xmlDocument;

  LexicalResource(this.xmlDocument);

  Iterable<XmlElement> get lexicalEntries {
    return xmlDocument.findAllElements('LexicalEntry');
  }

  Iterable<XmlElement> get synsets {
    return xmlDocument.findAllElements('Synset');
  }

  Iterable<XmlElement> findLexicalEntries(PartOfSpeech partOfSpeech) {
    return lexicalEntries.where((element) =>
        element.findElements('Lemma').first.getAttribute('partOfSpeech') ==
        partOfSpeech.name);
  }
}

String toLemmaWrittenForm(XmlElement entry) {
  return entry.findElements('Lemma').first.getAttribute('writtenForm')!;
}

Future<void> updateCachedDeWordNet() async {
  final appCacheDir = Directory(path.join(xdg.cacheHome.path, 'odenet-wordnet-de'));
  if (!await appCacheDir.exists()) {
    await appCacheDir.create(recursive: true);
  }
  final file = File(path.join(appCacheDir.path, 'deWordNet.xml'));

  final url = Uri.parse(deWordNetUrl);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    await file.writeAsString(response.body);
  } else {
    throw Exception('Failed to download deWordNet.xml: ${response.statusCode}');
  }
}

Future<LexicalResource> loadDeWordNetLexicalResource() async {
  final appCacheDir = Directory(path.join(xdg.cacheHome.path, 'odenet-wordnet-de'));
  final file = File(path.join(appCacheDir.path, 'deWordNet.xml'));

  if (!await file.exists()) {
    throw Exception('deWordNet.xml not found in cache. Please run updateCachedDeWordNet first.');
  }
  final contents = await file.readAsString();
  final document = XmlDocument.parse(contents);
  return LexicalResource(document);
}
