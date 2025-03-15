import 'package:xml/xml.dart';
import 'dart:io';

// See https://globalwordnet.github.io/schemas/

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

LexicalResource getDeWordNetLexicalResource() {
  final file = File('wordnet/deWordNet.xml');
  final contents = file.readAsStringSync();
  final document = XmlDocument.parse(contents);
  return LexicalResource(document);
}
