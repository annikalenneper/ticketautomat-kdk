import 'package:shared_preferences/shared_preferences.dart';

/// Model für Button-Push-Daten
class ButtonPushData {
  final DateTime timestamp;

  ButtonPushData(this.timestamp);

  factory ButtonPushData.fromIso8601(String iso) {
    return ButtonPushData(DateTime.parse(iso));
  }

  String toIso8601() => timestamp.toIso8601String();
}

/// Service für Button-Metriken
class ButtonMetricsService {
  static const String _timestampsKey = 'push_button_timestamps';

  /// Lädt alle Button-Push-Daten
  static Future<List<ButtonPushData>> loadPushData() async {
    final prefs = await SharedPreferences.getInstance();
    final timestampsJson = prefs.getStringList(_timestampsKey) ?? [];
    return timestampsJson.map((ts) => ButtonPushData.fromIso8601(ts)).toList();
  }

  /// Speichert einen neuen Push
  static Future<void> recordPush(List<ButtonPushData> existing) async {
    final prefs = await SharedPreferences.getInstance();
    final newPush = ButtonPushData(DateTime.now());
    existing.add(newPush);
    await prefs.setStringList(
      _timestampsKey,
      existing.map((p) => p.toIso8601()).toList(),
    );
  }
}

/// Berechnete Metriken für die Anzeige
class ButtonMetrics {
  final List<ButtonPushData> pushData;

  ButtonMetrics(this.pushData);

  /// Gesamtzahl der Pushes
  int get totalPushes => pushData.length;

  /// Pushes in der letzten Stunde
  int get pushesLastHour {
    final lastHour = DateTime.now().subtract(const Duration(hours: 1));
    return pushData.where((p) => p.timestamp.isAfter(lastHour)).length;
  }

  /// Pushes heute
  int get pushesToday {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return pushData.where((p) => p.timestamp.isAfter(todayStart)).length;
  }

  /// Erster Push
  DateTime? get firstPush => pushData.isNotEmpty ? pushData.first.timestamp : null;

  /// Letzter Push
  DateTime? get lastPush => pushData.isNotEmpty ? pushData.last.timestamp : null;

  /// Durchschnittliche Pushes pro Stunde (basierend auf aktivem Zeitraum)
  double get averagePushesPerHour {
    if (pushData.isEmpty) return 0;
    final first = pushData.first.timestamp;
    final last = pushData.last.timestamp;
    final duration = last.difference(first);
    if (duration.inHours == 0) return pushData.length.toDouble();
    return pushData.length / duration.inHours;
  }

  /// Pushes gruppiert nach Stunde (für Chart)
  /// Gibt Map von Stunde (0-23) zu Anzahl Pushes zurück
  Map<int, int> get pushesPerHourOfDay {
    final Map<int, int> result = {};
    for (int i = 0; i < 24; i++) {
      result[i] = 0;
    }
    for (final push in pushData) {
      result[push.timestamp.hour] = (result[push.timestamp.hour] ?? 0) + 1;
    }
    return result;
  }

  /// Pushes der letzten 7 Tage (für Chart)
  /// Gibt Map von Wochentag (0=heute, 6=vor 6 Tagen) zu Anzahl zurück
  Map<int, int> get pushesLast7Days {
    final Map<int, int> result = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      result[i] = 0;
    }
    
    for (final push in pushData) {
      final diff = now.difference(push.timestamp).inDays;
      if (diff >= 0 && diff < 7) {
        result[diff] = (result[diff] ?? 0) + 1;
      }
    }
    return result;
  }

  /// Pushes der letzten 4 Tage (für Chart)
  Map<int, int> get pushesLast4Days {
    final Map<int, int> result = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 4; i++) {
      result[i] = 0;
    }
    
    for (final push in pushData) {
      final diff = now.difference(push.timestamp).inDays;
      if (diff >= 0 && diff < 4) {
        result[diff] = (result[diff] ?? 0) + 1;
      }
    }
    return result;
  }

  /// Pushes der letzten 12 Stunden (für Chart)
  Map<int, int> get pushesLast12Hours {
    final Map<int, int> result = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 12; i++) {
      result[i] = 0;
    }
    
    for (final push in pushData) {
      final diff = now.difference(push.timestamp).inHours;
      if (diff >= 0 && diff < 12) {
        result[diff] = (result[diff] ?? 0) + 1;
      }
    }
    return result;
  }

  /// Pushes pro Tag (Do 12.02 - So 15.02)
  /// Jeder Tag geht bis 07:00 Uhr Folgetag
  Map<String, int> get pushesPerDay {
    final Map<String, int> result = {
      'Do': 0,
      'Fr': 0,
      'Sa': 0,
      'So': 0,
    };
    
    // Feste Datumsgrenzen (jeweils bis 07:00 Folgetag)
    // Do: 12.02.2026 00:00 - 13.02.2026 07:00
    // Fr: 13.02.2026 07:00 - 14.02.2026 07:00
    // Sa: 14.02.2026 07:00 - 15.02.2026 07:00
    // So: 15.02.2026 07:00 - 16.02.2026 07:00
    
    final doStart = DateTime(2026, 2, 12, 0, 0);
    final doEnd = DateTime(2026, 2, 13, 7, 0);
    final frStart = DateTime(2026, 2, 13, 7, 0);
    final frEnd = DateTime(2026, 2, 14, 7, 0);
    final saStart = DateTime(2026, 2, 14, 7, 0);
    final saEnd = DateTime(2026, 2, 15, 7, 0);
    final soStart = DateTime(2026, 2, 15, 7, 0);
    final soEnd = DateTime(2026, 2, 16, 7, 0);
    
    for (final push in pushData) {
      final ts = push.timestamp;
      
      if (ts.isAfter(doStart) && ts.isBefore(doEnd) || ts.isAtSameMomentAs(doStart)) {
        result['Do'] = (result['Do'] ?? 0) + 1;
      } else if ((ts.isAfter(frStart) || ts.isAtSameMomentAs(frStart)) && ts.isBefore(frEnd)) {
        result['Fr'] = (result['Fr'] ?? 0) + 1;
      } else if ((ts.isAfter(saStart) || ts.isAtSameMomentAs(saStart)) && ts.isBefore(saEnd)) {
        result['Sa'] = (result['Sa'] ?? 0) + 1;
      } else if ((ts.isAfter(soStart) || ts.isAtSameMomentAs(soStart)) && ts.isBefore(soEnd)) {
        result['So'] = (result['So'] ?? 0) + 1;
      }
    }
    
    return result;
  }

  /// Formatiert ein Datum für Anzeige
  static String formatDateTime(DateTime? dt) {
    if (dt == null) return 'Noch kein Push';
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  /// Formatiert eine Zeitspanne
  static String formatDuration(Duration? duration) {
    if (duration == null) return '-';
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Zeitspanne seit erstem Push
  Duration? get timeSinceFirstPush {
    if (firstPush == null) return null;
    return DateTime.now().difference(firstPush!);
  }
}
