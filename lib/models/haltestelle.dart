import 'dart:convert';
import 'package:flutter/services.dart';

class Haltestelle {
  final String name;
  final String preis;
  final String fahrzeit;
  final String zwischenstopps;
  final String? dialog;

  Haltestelle({
    required this.name,
    required this.preis,
    required this.fahrzeit,
    required this.zwischenstopps,
    this.dialog,
  });

  factory Haltestelle.fromJson(Map<String, dynamic> json) {
    final dialogValue = json['Dialog 1'] as String?;
    return Haltestelle(
      name: json['Name'] as String,
      preis: json['Preis'] as String,
      fahrzeit: json['Fahrzeit'] as String,
      zwischenstopps: json['Zwischenstopps'] as String,
      dialog: (dialogValue != null && dialogValue.isNotEmpty) ? dialogValue : null,
    );
  }
}

class HaltestellenService {
  static List<Haltestelle>? _cachedHaltestellen;

  static Future<List<Haltestelle>> loadHaltestellen() async {
    if (_cachedHaltestellen != null) {
      return _cachedHaltestellen!;
    }

    final jsonString = await rootBundle.loadString('lib/assets/haltestellen.json');
    final jsonData = json.decode(jsonString) as List<dynamic>;
    
    _cachedHaltestellen = jsonData
        .map((item) => Haltestelle.fromJson(item as Map<String, dynamic>))
        .toList();
    
    return _cachedHaltestellen!;
  }

  static Haltestelle? findByName(String name) {
    if (_cachedHaltestellen == null) return null;
    try {
      return _cachedHaltestellen!.firstWhere((h) => h.name == name);
    } catch (e) {
      return null;
    }
  }
}
