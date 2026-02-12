import 'dart:io';
import 'package:print_bluetooth_thermal/post_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ticket_template.dart';

class BluetoothDevice {
  final String name;
  final String macAddress;

  BluetoothDevice({
    required this.name,
    required this.macAddress,
  });
}

class PrintService {
  static final PrintService _instance = PrintService._internal();
  static const String _defaultPrinterKey = 'default_printer_mac';

  factory PrintService() {
    return _instance;
  }

  PrintService._internal();

  bool _isConnected = false;
  String? _savedPrinterMac;
  Future<bool>? _autoConnectFuture;

  /// Speichere Standard-Drucker MAC-Adresse
  Future<void> saveDefaultPrinter(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultPrinterKey, macAddress);
    _savedPrinterMac = macAddress;
  }

  /// Lade Standard-Drucker MAC-Adresse
  Future<String?> getDefaultPrinter() async {
    if (_savedPrinterMac != null) return _savedPrinterMac;
    final prefs = await SharedPreferences.getInstance();
    _savedPrinterMac = prefs.getString(_defaultPrinterKey);
    return _savedPrinterMac;
  }

  /// Automatisch mit gespeichertem Drucker verbinden (verhindert Race-Conditions)
  Future<bool> autoConnect() async {
    if (_autoConnectFuture != null) return _autoConnectFuture!;

    _autoConnectFuture = _performAutoConnect();
    try {
      return await _autoConnectFuture!;
    } finally {
      _autoConnectFuture = null;
    }
  }

  Future<bool> _performAutoConnect() async {
    // 1. Prüfe ob bereits eine aktive Verbindung besteht
    if (_isConnected) {
      final status = await checkConnectionStatus();
      if (status) return true;
    }

    // 2. Scanne nach gepairten Druckern
    final printers = await scanForPrinters();
    if (printers.isEmpty) return false;

    // 3. Hole gespeicherten Drucker
    final savedMac = await getDefaultPrinter();

    // 4. Fallunterscheidung für die Verbindung
    if (savedMac != null) {
      // Prüfe ob der gespeicherte Drucker in der Liste der verfügbaren/gepairten ist
      final isSavedStillAvailable = printers.any((p) => p.macAddress == savedMac);
      
      if (isSavedStillAvailable) {
        // Versuche mit dem bekannten Drucker zu verbinden
        final success = await connectPrinter(savedMac);
        if (success) return true;
      }
    }

    // 5. Fallback: Nimm den ersten verfügbaren gepairten Drucker
    // Dies deckt den Fall ab, dass ein neuer Drucker verbunden wurde
    final firstPrinterMac = printers.first.macAddress;
    final success = await connectPrinter(firstPrinterMac);
    
    if (success) {
      // Aktualisiere den Standard-Drucker für das nächste Mal
      await saveDefaultPrinter(firstPrinterMac);
      return true;
    }

    return false;
  }

  /// Scanne nach verfügbaren Bluetooth-Druckern
  Future<List<BluetoothDevice>> scanForPrinters() async {
    try {
      final List<BluetoothInfo> pairedDevices =
          await PrintBluetoothThermal.pairedBluetooths;

      return pairedDevices
          .map((device) => BluetoothDevice(
                name: device.name,
                macAddress: device.macAdress,
              ))
          .toList();
    } catch (e) {
      throw Exception('Fehler beim Scannen: $e');
    }
  }

  /// Verbinde mit einem Bluetooth-Drucker
  Future<bool> connectPrinter(String macAddress) async {
    try {
      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );
      _isConnected = result;
      return result;
    } catch (e) {
      _isConnected = false;
      throw Exception('Fehler beim Verbinden: $e');
    }
  }

  /// Minimaler Drucktest - nur "Test" drucken
  Future<bool> printTest() async {
    final connected = await autoConnect();
    if (!connected) {
      throw Exception('Drucker nicht bereit');
    }

    try {
      List<int> bytes = [];
      bytes += PostCode.text(text: 'Test', align: AlignPos.left);
      bytes += PostCode.enter();
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      throw Exception('Drucktest fehlgeschlagen: $e');
    }
  }

  /// Drucke ein Ticket
  Future<bool> printTicket(TicketData ticketData) async {
    // Sicherstellen, dass wir wirklich verbunden sind
    // autoConnect prüft intern den Status und verbindet neu falls nötig
    final connected = await autoConnect();
    if (!connected) {
      throw Exception('Drucker konnte nicht verbunden werden. Bitte in den Einstellungen prüfen.');
    }

    try {
      bool result;

      // Einheitliche Nutzung von ESC/POS über buildFinalTicket für alle Plattformen,
      // da die meisten Bluetooth-Thermodrucker diesen Standard erwarten.
      // Dies behebt potentielle Inkompatibilitäten mit PostCode auf Windows.
      final bytes = await buildFinalTicket(ticketData);
      result = await PrintBluetoothThermal.writeBytes(bytes);

      return result;
    } catch (e) {
      throw Exception('Fehler beim Druckvorgang: $e');
    }
  }

  /// Trenne die Verbindung
  Future<void> disconnectPrinter() async {
    try {
      await PrintBluetoothThermal.disconnect;
      _isConnected = false;
    } catch (e) {
      throw Exception('Fehler beim Trennen: $e');
    }
  }

  /// Prüfe Verbindungsstatus
  Future<bool> checkConnectionStatus() async {
    try {
      final result = await PrintBluetoothThermal.connectionStatus;
      _isConnected = result;
      return result;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  /// Drucke rohe Bytes (für Quest-Tickets etc.)
  Future<bool> printRawBytes(List<int> bytes) async {
    // Sicherstellen, dass wir wirklich verbunden sind
    final connected = await autoConnect();
    if (!connected) {
      throw Exception('Drucker nicht verbunden');
    }

    try {
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      throw Exception('Fehler beim Drucken der Rohdaten: $e');
    }
  }

  /// Prüfe ob Bluetooth aktiviert ist
  Future<bool> isBluetoothEnabled() async {
    try {
      return await PrintBluetoothThermal.bluetoothEnabled;
    } catch (e) {
      return false;
    }
  }

  bool get isConnected => _isConnected;
}

