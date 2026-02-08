import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

Future<List<int>> buildFinalTicket(TicketData ticketData) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);

  final bytes = <int>[];

  // Header / Logo
  bytes.addAll(generator.text(
    r'''
==============================
          K d K
   KARNEVAL DER KOLLEKTIVE
==============================
''',
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

  bytes.addAll(generator.feed(1));

  // Ticket Data
  bytes.addAll(generator.text('Von:   ${ticketData.from}'));
  bytes.addAll(generator.text('Nach:  ${ticketData.to}'));
  bytes.addAll(generator.feed(1));

  bytes.addAll(generator.text('Gültig ab: ${ticketData.formattedDateTime}'));
  bytes.addAll(generator.text('Preis:     ${ticketData.formattedPrice}'));

  bytes.addAll(generator.feed(1));

  // Footer
  bytes.addAll(generator.text(
    '------------------------------',
    styles: PosStyles(align: PosAlign.center),
  ));

  bytes.addAll(generator.text(
    'OEFFENTLICHER RAUM\nGEHOERT UNS ALLEN.',
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
  final double price;
  final String ticketType;

  TicketData({
    required this.from,
    required this.to,
    required this.dateTime,
    required this.price,
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

  String get formattedPrice {
    return '${price.toStringAsFixed(2)} EUR';
  }
}
