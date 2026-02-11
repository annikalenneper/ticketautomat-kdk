import 'dart:convert';
import 'package:flutter/services.dart';

class Haltestelle {
  final String name;
  final String preis;
  final String fahrzeit;
  final int zwischenstopps;
  final String? dialog;

  Haltestelle({
    required this.name,
    required this.preis,
    required this.fahrzeit,
    required this.zwischenstopps,
    this.dialog,
  });

  factory Haltestelle.fromJson(Map<String, dynamic> json) {
    return Haltestelle(
      name: json['name'] as String,
      preis: json['preis'] as String,
      fahrzeit: json['fahrzeit'] as String,
      zwischenstopps: json['zwischenstopps'] as int,
      dialog: json['dialog'] as String?,
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
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final haltestellenList = jsonData['haltestellen'] as List;
    
    _cachedHaltestellen = haltestellenList
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
