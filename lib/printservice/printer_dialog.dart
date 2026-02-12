import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'print_service.dart';
import 'ticket_template.dart';
import 'quest_ticket.dart';

/// Abstrakter Print-Inhalt
sealed class PrintContent {
  const PrintContent();
  
  /// Titel für den Dialog-Header
  String get dialogTitle;
  
  /// Farbe für den Header
  Color get headerColor;
  
  /// Erfolgsmeldung
  String get successMessage;
  
  /// Status-Text beim Drucken
  String get printingMessage;
  
  /// Baut die Vorschau-Widget
  Widget buildPreview();
  
  /// Führt den Druckvorgang aus
  Future<bool> print(PrintService service);
}

/// Ticket-Inhalt für Fahrten
class TicketContent extends PrintContent {
  final String from;
  final String to;
  final String preis;
  final String fahrzeit;

  const TicketContent({
    required this.from,
    required this.to,
    required this.preis,
    required this.fahrzeit,
  });

  @override
  String get dialogTitle => 'Drucker auswählen';

  @override
  Color get headerColor => AppColors.primary;

  @override
  String get successMessage => 'Ticket erfolgreich gedruckt!';

  @override
  String get printingMessage => 'Drucke Ticket...';

  @override
  Widget buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPreviewRow('Von:', from),
        const SizedBox(height: 8),
        _buildPreviewRow('Nach:', to),
        const SizedBox(height: 8),
        _buildPreviewRow('Fahrzeit:', fahrzeit),
        const SizedBox(height: 8),
        _buildPreviewRow('Preis:', preis),
      ],
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Future<bool> print(PrintService service) async {
    final ticketData = TicketData(
      from: from,
      to: to,
      dateTime: DateTime.now(),
      preis: preis,
      fahrzeit: fahrzeit,
      ticketType: 'Einzelticket',
    );
    return await service.printTicket(ticketData);
  }
}

/// Quest-Inhalt für Quests
class QuestContent extends PrintContent {
  final String category;
  final String questText;

  const QuestContent({
    required this.category,
    required this.questText,
  });

  @override
  String get dialogTitle => 'Quest drucken';

  @override
  Color get headerColor => AppColors.secondary;

  @override
  String get successMessage => 'Quest erfolgreich gedruckt!';

  @override
  String get printingMessage => 'Drucke Quest...';

  @override
  Widget buildPreview() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.all(color: AppColors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KATEGORIE: ${category.toUpperCase()}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'AUFGABE:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            questText,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Future<bool> print(PrintService service) async {
    final questBytes = await buildQuestTicket(
      category: category,
      questText: questText,
    );
    return await service.printRawBytes(questBytes);
  }
}

/// Gemeinsamer Drucker-Dialog für alle Print-Inhalte
class PrinterDialog extends StatefulWidget {
  final PrintContent content;

  const PrinterDialog({
    super.key,
    required this.content,
  });

  /// Factory für Ticket-Druck
  factory PrinterDialog.ticket({
    Key? key,
    required String from,
    required String to,
    required String preis,
    required String fahrzeit,
  }) {
    return PrinterDialog(
      key: key,
      content: TicketContent(from: from, to: to, preis: preis, fahrzeit: fahrzeit),
    );
  }

  /// Factory für Quest-Druck
  factory PrinterDialog.quest({
    Key? key,
    required String category,
    required String questText,
  }) {
    return PrinterDialog(
      key: key,
      content: QuestContent(category: category, questText: questText),
    );
  }

  @override
  State<PrinterDialog> createState() => _PrinterDialogState();
}

class _PrinterDialogState extends State<PrinterDialog> {
  late Future<List<BluetoothDevice>> _printers;
  bool _isConnecting = false;
  bool _isPrinting = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _printers = _initializeAndScan();
  }

  Future<List<BluetoothDevice>> _initializeAndScan() async {
    try {
      final isEnabled = await PrintService().isBluetoothEnabled();
      if (!isEnabled) {
        setState(() {
          _statusMessage = 'Bluetooth ist nicht aktiviert';
        });
      }
      return await PrintService().scanForPrinters();
    } catch (e) {
      setState(() {
        _statusMessage = 'Fehler beim Scannen: $e';
      });
      return [];
    }
  }

  Future<void> _connectAndPrint(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Verbinde mit ${device.name}...';
    });

    try {
      final connected = await PrintService().connectPrinter(device.macAddress);

      if (!connected) {
        throw Exception('Verbindung fehlgeschlagen');
      }

      setState(() {
        _isPrinting = true;
        _statusMessage = widget.content.printingMessage;
      });

      final printResult = await widget.content.print(PrintService());

      if (printResult) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.content.successMessage),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        throw Exception('Druckfehler');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Fehler: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: AppColors.cancel,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _isPrinting = false;
        });
        // Geben Sie dem Drucker Zeit, den Puffer zu verarbeiten, bevor die Verbindung getrennt wird
        await Future.delayed(const Duration(milliseconds: 500));
        // Wir trennen die Verbindung nicht zwingend sofort, um die Verbindung für den nächsten Druckvorgang offen zu halten
        // Falls gewünscht, kann disconnectPrinter() hier wieder aktiviert werden:
        // await PrintService().disconnectPrinter();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.content.headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                widget.content.dialogTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            // Vorschau für Quest-Content
            if (widget.content is QuestContent)
              Padding(
                padding: const EdgeInsets.all(15),
                child: widget.content.buildPreview(),
              ),
            // Status-Nachricht
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('Fehler')
                        ? AppColors.cancel
                        : AppColors.textDark,
                  ),
                ),
              ),
            // Lade-Indikator
            if (_isConnecting || _isPrinting)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              )
            else
              // Drucker-Liste
              _buildPrinterList(),
            // Buttons
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrinterList() {
    return FutureBuilder<List<BluetoothDevice>>(
      future: _printers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Text('Fehler: ${snapshot.error}'),
          );
        }

        final printers = snapshot.data ?? [];

        if (printers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Keine Drucker gefunden'),
          );
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: printers.length,
            itemBuilder: (context, index) {
              final printer = printers[index];
              return ListTile(
                leading: const Icon(Icons.print),
                title: Text(printer.name),
                subtitle: Text(printer.macAddress),
                onTap: () => _connectAndPrint(printer),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _printers = _initializeAndScan();
              });
            },
            child: const Text('Neu scannen'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cancel,
            ),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }
}
