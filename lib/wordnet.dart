import 'package:xml/xml.dart';
import 'dart:io';

class LexicalResource {
  final XmlDocument xmlDocument;

  LexicalResource(this.xmlDocument);

  Iterable<XmlElement> get lexicalEntries {
    return xmlDocument.findAllElements('LexicalEntry');
  }

  Iterable<XmlElement> get synsets {
    return xmlDocument.findAllElements('Synset');
  }
}

LexicalResource getDeWordNetLexicalResource() {
  final file = File('wordnet/deWordNet.xml');
  final contents = file.readAsStringSync();
  final document = XmlDocument.parse(contents);
  return LexicalResource(document);
}
