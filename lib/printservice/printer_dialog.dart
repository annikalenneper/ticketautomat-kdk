import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'print_service.dart';
import 'ticket_template.dart';

class PrinterDialog extends StatefulWidget {
  final String from;
  final String to;
  final String preis;

  const PrinterDialog({
    super.key,
    required this.from,
    required this.to,
    required this.preis,
  });

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
        _statusMessage = 'Drucke Ticket...';
      });

      final ticketData = TicketData(
        from: widget.from,
        to: widget.to,
        dateTime: DateTime.now(),
        preis: widget.preis,
        ticketType: 'Einzelticket',
      );

      final printResult = await PrintService().printTicket(ticketData);

      if (printResult) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket erfolgreich gedruckt!'),
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
        await PrintService().disconnectPrinter();
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Text(
                'Drucker auswählen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 14,
                  ),
                ),
              ),
            Flexible(
              child: FutureBuilder<List<BluetoothDevice>>(
                future: _printers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Suche nach Druckern...'),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Fehler: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.print_disabled,
                            size: 48,
                            color: AppColors.textMedium,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Keine Drucker gefunden.\n\nStelle sicher, dass dein Drucker:\n- Eingeschaltet ist\n- Mit deinem Gerät gekoppelt ist',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final device = snapshot.data![index];
                      final isDisabled = _isConnecting || _isPrinting;

                      return ListTile(
                        leading: Icon(
                          Icons.print,
                          color: isDisabled
                              ? AppColors.inputBorder
                              : AppColors.primary,
                        ),
                        title: Text(
                          device.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDisabled
                                ? AppColors.inputBorder
                                : AppColors.textDark,
                          ),
                        ),
                        subtitle: Text(
                          device.macAddress,
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: isDisabled
                            ? null
                            : () => _connectAndPrint(device),
                        enabled: !isDisabled,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isConnecting || _isPrinting)
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cancel,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    disabledBackgroundColor: AppColors.inputBorder,
                  ),
                  child: const Text('Abbrechen'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
