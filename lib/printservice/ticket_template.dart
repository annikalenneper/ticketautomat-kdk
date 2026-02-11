import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// Text an Wortgrenzen umbrechen (max 32 Zeichen fuer 58mm Drucker)
String wrapText(String text, {int maxWidth = 32}) {
  if (text.length <= maxWidth) return text;
  
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

Future<List<int>> buildFinalTicket(TicketData ticketData) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);

  final bytes = <int>[];

  // Codepage fuer deutsche Umlaute setzen
  bytes.addAll(generator.setGlobalCodeTable('CP1252'));

  // Logo aus Assets laden
  try {
    final ByteData logoData = await rootBundle.load('lib/img/LOG.jpeg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final img.Image? logo = img.decodeImage(logoBytes);
    
    if (logo != null) {
      // Bild skalieren
      final img.Image resizedLogo = img.copyResize(logo, width: 200);
      // Farben invertieren
      final img.Image invertedLogo = img.invert(resizedLogo);
      bytes.addAll(generator.image(invertedLogo));
      bytes.addAll(generator.feed(1));
    }
  } catch (e) {
    // Fallback: Text-Header wenn Bild nicht geladen werden kann
    bytes.addAll(generator.text(
      '================================',
      styles: PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      'K  D  K',
      styles: PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.text(
      'KARNEVAL DER KOLLEKTIVE',
      styles: PosStyles(align: PosAlign.center, bold: true),
    ));
    bytes.addAll(generator.text(
      '================================',
      styles: PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(1));
  }

  // Header Text
  bytes.addAll(generator.text(
    '--------------------------------',
    styles: PosStyles(align: PosAlign.center),
  ));
  bytes.addAll(generator.text(
    'TICKET / FAHRKARTE',
    styles: PosStyles(align: PosAlign.center, bold: true),
  ));
  bytes.addAll(generator.text(
    '--------------------------------',
    styles: PosStyles(align: PosAlign.center),
  ));

  // Ticket Title
  bytes.addAll(generator.text(
    ticketData.ticketType.toUpperCase(),
    styles: PosStyles(
      align: PosAlign.center,
      bold: true,
    ),
  ));

  bytes.addAll(generator.feed(2));

  // Ticket Data (mit Wort-Umbruch)
  bytes.addAll(generator.text(wrapText('Von: ${ticketData.from}')));
  bytes.addAll(generator.text(wrapText('Nach: ${ticketData.to}')));
  bytes.addAll(generator.feed(2));

  bytes.addAll(generator.text(wrapText('Gültig ab: ${ticketData.formattedDateTime}')));
  bytes.addAll(generator.text(wrapText('Preis: ${ticketData.preis}')));

  bytes.addAll(generator.feed(2));
  // Footer
  bytes.addAll(generator.text(
    '------------------------------',
    styles: PosStyles(align: PosAlign.center),
  ));

  bytes.addAll(generator.text(
    'GUTE FAHRT!',
    styles: PosStyles(
      align: PosAlign.center,
      bold: true,
    ),
  ));
  bytes.addAll(generator.text(
    'Hab Spaß & achte auf andere.',
    styles: PosStyles(align: PosAlign.center),
  ));

  bytes.addAll(generator.text(
    '------------------------------',
    styles: PosStyles(align: PosAlign.center),
  ));

  bytes.addAll(generator.feed(2));
  bytes.addAll(generator.cut());

  return bytes;
}

/// Ticket-Datenmodell
class TicketData {
  final String from;
  final String to;
  final DateTime dateTime;
  final String preis;
  final String ticketType;

  TicketData({
    required this.from,
    required this.to,
    required this.dateTime,
    required this.preis,
    this.ticketType = 'Einzelticket',
  });

  String get formattedDateTime {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute Uhr';
  }
}
