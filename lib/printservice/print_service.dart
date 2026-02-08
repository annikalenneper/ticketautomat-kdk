import 'dart:io';
import 'package:print_bluetooth_thermal/post_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
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

  factory PrintService() {
    return _instance;
  }

  PrintService._internal();

  bool _isConnected = false;

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
      throw Exception('Fehler beim Verbinden: $e');
    }
  }

  /// Drucke ein Ticket
  Future<bool> printTicket(TicketData ticketData) async {
    if (!_isConnected) {
      throw Exception('Drucker nicht verbunden');
    }

    try {
      bool result;

      if (Platform.isWindows) {
        // Windows: Nutze PostCode für Thermodrucker
        List<int> bytes = await _buildTicketBytesWindows(ticketData);
        result = await PrintBluetoothThermal.writeBytes(bytes);
      } else {
        // Android/iOS: Nutze ESC/POS
        final bytes = await buildFinalTicket(ticketData);
        result = await PrintBluetoothThermal.writeBytes(bytes);
      }

      return result;
    } catch (e) {
      throw Exception('Fehler beim Drucken: $e');
    }
  }

  /// Generiere Bytes für Windows
  Future<List<int>> _buildTicketBytesWindows(TicketData ticketData) async {
    List<int> bytes = [];

    bytes += PostCode.text(
      text: '==============================',
      align: AlignPos.center,
    );
    bytes += PostCode.text(
      text: 'KVB TICKETAUTOMAT',
      align: AlignPos.center,
      bold: true,
    );
    bytes += PostCode.text(
      text: '==============================',
      align: AlignPos.center,
    );
    bytes += PostCode.enter();

    bytes += PostCode.text(
      text: 'Von: ${ticketData.from}',
      fontSize: FontSize.normal,
    );
    bytes += PostCode.text(
      text: 'Nach: ${ticketData.to}',
      fontSize: FontSize.normal,
    );
    bytes += PostCode.enter();

    bytes += PostCode.text(
      text: 'Gültig ab: ${ticketData.formattedDateTime}',
      fontSize: FontSize.compressed,
    );
    bytes += PostCode.text(
      text: 'Preis: ${ticketData.formattedPrice}',
      fontSize: FontSize.compressed,
    );
    bytes += PostCode.enter();

    bytes += PostCode.text(
      text: '==============================',
      align: AlignPos.center,
    );
    bytes += PostCode.text(
      text: 'Vielen Dank!',
      align: AlignPos.center,
      bold: true,
    );
    bytes += PostCode.enter(nEnter: 3);

    return bytes;
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
      return false;
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

