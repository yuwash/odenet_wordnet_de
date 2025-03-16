Open German WordNet (Dart)
==========================

Dart library and simple CLI app for Open German WordNet.

Uses `deWordNet.xml` from
[hdaSprachtechnologie/odenet](https://github.com/hdaSprachtechnologie/odenet)
in the [WordNet XML schema](https://globalwordnet.github.io/schemas/).

## Usage

To use the `wordnet.dart` library:

```dart
import 'package:odenet_wordnet_de/wordnet.dart';

void main() {
  final resource = getDeWordNetLexicalResource();
  print('Number of lexical entries: ${resource.lexicalEntries.length}');

  // Accessing lexical entries and synsets
  print('Lexical entries: ${resource.lexicalEntries.length}');
  print('Synsets: ${resource.synsets.length}');

  // Finding lexical entries by part of speech
  final nouns = resource.findLexicalEntries(PartOfSpeech.n);
  print('Number of nouns: ${nouns.length}');

  // Extract the lemma string (word)
  final firstLemma = resource.lexicalEntries.map(toLemmaWrittenForm).first;
}
```

## LexicalResource methods

* `lexicalEntries`: Returns an `Iterable<XmlElement>` of all lexical entries.
* `synsets`: Returns an `Iterable<XmlElement>` of all synsets.
* `findLexicalEntries(PartOfSpeech partOfSpeech)`: Returns an `Iterable<XmlElement>` of lexical entries filtered by part of speech.

## License

The Open German WordNet is openly licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

## Citation

The canonical citation(s) are in
[citation.bib](https://github.com/hdaSprachtechnologie/odenet/blob/master/citation.bib),
in bibtex format. Please cite them when you write a paper that uses (or
refers to) OdeNet.
