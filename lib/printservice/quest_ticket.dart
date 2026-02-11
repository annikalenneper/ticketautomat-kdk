import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

/// Bricht Text an Wortgrenzen um
String _wrapText(String text, int maxWidth) {
  final words = text.split(' ');
  final lines = <String>[];
  var currentLine = '';

  for (final word in words) {
    if (currentLine.isEmpty) {
      currentLine = word;
    } else if ((currentLine.length + 1 + word.length) <= maxWidth) {
      currentLine += ' $word';
    } else {
      lines.add(currentLine);
      currentLine = word;
    }
  }
  if (currentLine.isNotEmpty) {
    lines.add(currentLine);
  }

  return lines.join('\n');
}

Future<List<int>> buildQuestTicket({
  required String category,
  required String questText,
}) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);

  // CP1252 für deutsche Umlaute
  generator.setGlobalCodeTable('CP1252');

  final bytes = <int>[];

  // HEADER
  bytes.addAll(generator.text(
    '================================',
    styles: const PosStyles(align: PosAlign.center),
  ));
  bytes.addAll(generator.text(
    'KARNEVAL DER KOLLEKTIVE',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2,
    ),
  ));
  bytes.addAll(generator.text(
    '================================',
    styles: const PosStyles(align: PosAlign.center),
  ));

  bytes.addAll(generator.feed(1));

  // QUEST KATEGORIE
  bytes.addAll(generator.text(
    'QUEST-KATEGORIE',
    styles: const PosStyles(bold: true),
  ));
  bytes.addAll(generator.text(category.toUpperCase()));

  bytes.addAll(generator.feed(1));

  // QUEST AUFGABE
  bytes.addAll(generator.text(
    'AUFGABE',
    styles: const PosStyles(bold: true),
  ));
  bytes.addAll(generator.text(_wrapText(questText, 32)));

  bytes.addAll(generator.feed(1));

  // FOOTER
  bytes.addAll(generator.text(
    '--------------------------------',
    styles: const PosStyles(align: PosAlign.center),
  ));
  bytes.addAll(generator.text(
    'VIEL GLÜCK!',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
    ),
  ));
  bytes.addAll(generator.text(
    'Hab Spaß & achte auf andere.',
    styles: const PosStyles(align: PosAlign.center),
  ));
  bytes.addAll(generator.text(
    '--------------------------------',
    styles: const PosStyles(align: PosAlign.center),
  ));

  bytes.addAll(generator.feed(2));
  bytes.addAll(generator.cut());

  return bytes;
}
