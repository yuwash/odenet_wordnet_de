import 'package:args/args.dart';
import 'package:odenet_wordnet_de/odenet_wordnet_de.dart';

const String version = '1.0.0';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addOption(
      'part-of-speech',
      abbr: 'p',
      allowed: PartOfSpeech.values.map((e) => e.name),
      help:
          'Filter lexical entries by part of speech (${PartOfSpeech.values.map((e) => e.name).join(', ')}).',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.')
    ..addCommand('lemma');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart odenet_wordnet_de.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('odenet_wordnet_de version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    LexicalResource resource;
    try {
      resource = await loadDeWordNetLexicalResource();
    } catch (e) {
      print('Updating cached deWordNet.xml from $deWordNetUrl...');
      await updateCachedDeWordNet();
      resource = await loadDeWordNetLexicalResource();
    }

    final String? selectedPartOfSpeech = results['part-of-speech'];
    if (results.command?.name == 'lemma') {
      Iterable<String> lemmaWrittenForms;

      if (selectedPartOfSpeech == null) {
        lemmaWrittenForms = resource.lexicalEntries.map(toLemmaWrittenForm);
      } else {
        final PartOfSpeech partOfSpeech = PartOfSpeech.values.byName(
          selectedPartOfSpeech,
        );
        lemmaWrittenForms = resource
            .findLexicalEntries(partOfSpeech)
            .map(toLemmaWrittenForm);
      }

      for (final entry in lemmaWrittenForms) {
        print(entry);
      }
    } else {
      if (selectedPartOfSpeech == null) {
        print('Number of lexical entries: ${resource.lexicalEntries.length}');
        print('Number of synsets: ${resource.synsets.length}');

        for (var p in PartOfSpeech.values) {
          print(
            'Number of ${partOfSpeechLabels[p]!} lexical entries: ${resource.findLexicalEntries(p).length}',
          );
        }
      } else {
        final PartOfSpeech partOfSpeech = PartOfSpeech.values.byName(
          selectedPartOfSpeech,
        );
        print(
          'Number of ${partOfSpeechLabels[partOfSpeech]!} lexical entries: ${resource.findLexicalEntries(partOfSpeech).length}',
        );
      }
    }

    if (verbose) {
      print('Positional arguments: ${results.rest}');
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
